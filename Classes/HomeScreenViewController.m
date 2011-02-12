//
//  HomeScreenViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "LineViewController.h"
#import "StopMapViewController.h"
#import "StopViewController.h"
#import "StopTimeViewController.h"
#import "CityViewController.h"
#import "AboutViewController.h"
#import "FavoritesViewController.h"
#import "Favorite.h"
#import "Line.h"
#import "Stop.h"
#import "StopTime.h"

#import "FavTimeViewCell.h"

@implementation HomeScreenViewController

@synthesize locationManager = locationManager_;

NSString* menuTitles[] = {
    @"Recherche par lignes",
    @"Recherche par arrêt",
    @"Favoris",
    @"Arrêts proches",
    @""
};
int LineMenuValues[] = {
    LINE_USAGE_URBAN,
    LINE_USAGE_SUBURBAN,
    LINE_USAGE_EXPRESS,
    LINE_USAGE_SPECIAL,
    LINE_USAGE_ALL,
    -1
};
int AboutMenuValues[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    -1
};

enum eSections {
    kLineSection,
    kStopsSection,
    kFavoritesSection,
    kCloseStopsSection,
    kAboutSection
};

#pragma mark -
#pragma mark View lifecycle

-(void)refreshViewOfFavorites {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kFavoritesSection] withRowAnimation:YES];
}

- (void)reloadFavorites {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray* favorites = [Favorite topFavorites];
    NSMutableArray* favtimes = [[NSMutableArray alloc] init];
    for ( Favorite* fav in favorites ) {
        [favtimes addObject:[StopTime findComingAt:fav]];
    }
    @synchronized(self) {
        if ( favoritesTimes_ != nil) {
            [favoritesTimes_ release];
        }
        favoritesTimes_ = [favtimes retain];
        cachedFavoritesCount = [Favorite count];
        topFavorites_ = [favorites retain];
    }
    [self performSelectorOnMainThread:@selector(refreshViewOfFavorites) withObject:nil waitUntilDone:NO];
    [pool release];
}

-(void)refreshViewOfCloseStops {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kCloseStopsSection] withRowAnimation:YES];
}

- (void)reloadCloseStops:(CLLocation*)location{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray* stops = [Stop findAroundLocation:location];
    closeStops = [stops retain];
    closeStopsCount = [stops count];
    NSLog( @"%d stops", [stops count] );
    [self performSelectorOnMainThread:@selector(refreshViewOfCloseStops) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)callFavLoading {
    [self performSelectorInBackground:@selector(reloadFavorites) withObject:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString( @"Accueil", @"" );
    menus_ = [[NSMutableArray alloc] init];
    [menus_ addObject:[NSArray arrayWithObjects:NSLocalizedString( @"Lignes urbaines", @""), 
					   NSLocalizedString( @"Lignes suburbaines", @""), 
					   NSLocalizedString( @"Lignes express", @""), 
					   NSLocalizedString( @"Lignes spéciales", @""), 
					   NSLocalizedString( @"Toutes les lignes", @""), /*@"Favorites",*/ nil ]];
    [menus_ addObject:[NSArray arrayWithObjects: NSLocalizedString( @"Arrêts par ville", @"" ), NSLocalizedString( @"Tous les arrêts", @"" ), NSLocalizedString( @"Sur la carte", @""), nil]];
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects: NSLocalizedString( @"À propos", @"" ), NSLocalizedString( @"Pas de panique", @"" ), nil ]];
    favoritesTimes_ =  [[NSMutableArray alloc] init];
    topFavorites_ = [NSArray arrayWithObjects:nil];
    cachedFavoritesCount = 0;
    [self callFavLoading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callFavLoading) name:@"favorites" object:nil];
    
    
    NSLog( @"Loading location manager" );
    closeStopsCount = 0;
    locationManager_ = [[CLLocationManager alloc] init];
    if ( locationManager_.locationServicesEnabled == YES ) {
        locationManager_.delegate = self;
        locationManager_.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // Set a movement threshold for new events
        locationManager_.distanceFilter = 100; // 10 km
        [locationManager_ startUpdatingLocation];
        NSLog( @"Loaded location manager" );
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark CoreLocation stuff

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"Location: %@ (%d)", [newLocation description], abs( [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp] ) );
    if ( oldLocation == nil || abs( [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp] ) > 20 ) {
        [self performSelectorInBackground:@selector(reloadCloseStops:) withObject:newLocation];
        [manager stopUpdatingLocation];
        [manager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        switch ([error code]) {
            case kCLErrorDenied:
                [manager stopUpdatingLocation];
                break;
                
            case kCLErrorLocationUnknown:
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sizeof(menuTitles) / sizeof(NSString*);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ( section != kFavoritesSection && section != kCloseStopsSection )
        return [[menus_ objectAtIndex:section] count];
    else if ( section == kCloseStopsSection ) {
        return closeStopsCount;
    } else {
        int topCount = [topFavorites_ count];
        if ( cachedFavoritesCount > topCount ) {
            return topCount + 1;
        } else if ( topCount > 0 ) {
            return topCount;
        } else {
            return 1;
        }
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierFavNone = @"CellFavNone";
    static NSString *CellIdentifierFavMore = @"CellFavMore";
    static NSString *CellIdentifierCloseStop = @"CellCloseStops";
    UITableViewCell *cell = nil;
    if ( indexPath.section != kFavoritesSection && indexPath.section != kCloseStopsSection ) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    // Configure the cell...
        cell.textLabel.text = [[menus_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else if ( indexPath.section == kCloseStopsSection ) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCloseStop];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierCloseStop] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        // Configure the cell...
        Stop* stop = [closeStops objectAtIndex:indexPath.row];
        cell.textLabel.text = stop.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d m", stop.distance];
    } else if ( indexPath.section == kFavoritesSection ) {

        int topCount = [topFavorites_ count];
        
        if ( topCount > 0 ) {
            if ( indexPath.row >= topCount ) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFavMore];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierFavMore] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.textLabel.text = NSLocalizedString( @"Voir tous les favoris", @"" );
                cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString( @"%d favoris enregistrés", @""), cachedFavoritesCount];
            } else {
                NSArray* times = nil;
                Favorite* fav = nil;
                fav = [topFavorites_ objectAtIndex:indexPath.row];
                times = [favoritesTimes_ objectAtIndex:indexPath.row];
                cell = [FavTimeViewCell cellFromNibNamed:@"FavTimeViewCell"];
                [(FavTimeViewCell*)cell displayFavorite:fav withTimes:times];
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFavNone];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierFavNone] autorelease];
            }
            cell.textLabel.text = NSLocalizedString( @"Aucun favori", @"" );
            cell.detailTextLabel.text = NSLocalizedString( @"Ajouter les depuis les pages d'horaires", @"");
        }

    }

    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString( menuTitles[section], @"" );
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    switch ( indexPath.section) {
        case kLineSection:
            if ( LineMenuValues[indexPath.row] > 0 ) {
                LineViewController* lineViewController = [[LineViewController alloc] initWithNibName:@"LineViewController" bundle:nil];
                lineViewController.usageType = LineMenuValues[indexPath.row];
                [self.navigationController pushViewController:lineViewController animated:YES];
                [lineViewController release];
            }
            break;
        case kStopsSection:
            if ( indexPath.row == 0 ) {
                CityViewController* cityViewController = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
                [self.navigationController pushViewController:cityViewController animated:YES];
                [cityViewController release];
            } else if ( indexPath.row == 1 ) {
                StopViewController* stopViewController = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
                [self.navigationController pushViewController:stopViewController animated:YES];
                [stopViewController release];
            } else {
                StopMapViewController* stopMapViewController = [[StopMapViewController alloc] initWithNibName:@"StopMapViewController" bundle:nil];
                [self.navigationController pushViewController:stopMapViewController animated:YES];
                [stopMapViewController release];
            }
            break;
        case kFavoritesSection:
        {
            int topCount = [topFavorites_ count];
            
            if ( topCount > 0 ) {
                if ( indexPath.row < topCount ) {
                    Favorite* fav = [topFavorites_ objectAtIndex:indexPath.row];
                    StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
                    stoptimeView.line = [Line findFirstBySrcId:fav.line_id];
                    stoptimeView.stop = [Stop findFirstBySrcId:fav.stop_id];
                    [self.navigationController pushViewController:stoptimeView animated:YES];
                    [stoptimeView release];                    
                } else {
                    FavoritesViewController* favViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
                    [self.navigationController pushViewController:favViewController animated:YES];
                    [favViewController release];
                    
                }
            }                
        }
            break;
        case kCloseStopsSection:
        {
            if ( closeStopsCount > 0 ) {
                StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
                stoptimeView.stop = [closeStops objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:stoptimeView animated:YES];
                [stoptimeView release];                    
            }
        }
            break;
        case kAboutSection:
        {
            if ( indexPath.row < 2 ) {
                AboutViewController* aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                aboutVC.type = AboutMenuValues[indexPath.row];
                [self.navigationController pushViewController:aboutVC animated:YES];
                [aboutVC release];
            }
        }
            break;
    }

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [favoritesTimes_ release];
    [menus_ release];
    [super dealloc];
}


@end

