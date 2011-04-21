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
#import "SimpleDeathStarAppDelegate.h"


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

enum ePositioningErrors {
    kNoPositionError = 0,
    kLocalisationServiceDisabledError,
    kPositionAcquisitionError,
    kOutOfBoundsPositionError
};

NSString* positioningErrorTexts[] = {
    @"Pas de données",
    @"Localisation impossible",
    @"Erreur d'acquisition",
    @"Inaccessible"
};

NSString* positioningErrorDetails[] = {
    @"Positionnement en cours",
    @"Localisation désactivée?",
    @"Vérifiez les autorisations",
    @"Habitant d'une galaxie lointaine?"
};

#pragma mark -
#pragma mark View lifecycle

-(void)refreshViewOfFavorites {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kFavoritesSection] withRowAnimation:YES];
}

- (void)reloadFavorites {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray* favorites = [[Favorite topFavorites] retain];
    NSMutableArray* favtimes = [[NSMutableArray alloc] initWithCapacity:[favorites count]];
    for ( Favorite* fav in favorites ) {
        [favtimes addObject:[StopTime findComingAt:fav]];
    }
    @synchronized(self) {
        [favoritesTimes_ release];
        favoritesTimes_ = [favtimes retain];
        cachedFavoritesCount = [Favorite count];
        NSArray* oldFavorites = topFavorites_;
        topFavorites_ = favorites;
        [oldFavorites release];
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
    [closeStops release];
    closeStops = [stops retain];
    closeStopsCount = [stops count];
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
    
    
//    NSLog( @"Loading location manager" );
    closeStopsCount = 0;
    closeStops = nil;
    locationManager_ = [[CLLocationManager alloc] init];
    [self locationRetry];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark CoreLocation stuff

BOOL checkBounds( CLLocation* location ) {
    const double N = 48.32;
    const double W = -2.02;
    const double S = 47.9;
    const double E = -1.3;
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    return ( ( latitude < N ) && ( latitude > S ) && ( longitude > W ) && ( longitude < E ) );
}

- (void)commitLocationUpdate {
    CLLocation* newLocation = locationManager_.location;
    if ( checkBounds( newLocation ) ) {
        [self performSelectorInBackground:@selector(reloadCloseStops:) withObject:newLocation];
    } else {
        positioningError = kOutOfBoundsPositionError;
        [self refreshViewOfCloseStops];            
    }
    [locationManager_ stopUpdatingLocation];
    [locationManager_ startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"Location: %@ (%d)", [newLocation description], abs( [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp] ) );
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(commitLocationUpdate) object:nil];
    [self performSelector:@selector(commitLocationUpdate) withObject:nil afterDelay:1];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
//    NSLog( @"location error %@", error );
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        switch ([error code]) {
            case kCLErrorDenied:
                [manager stopUpdatingLocation];
                positioningError = kPositionAcquisitionError;
                [self refreshViewOfCloseStops];
                break;
            case kCLErrorLocationUnknown:
                [manager stopUpdatingLocation];
                positioningError = kLocalisationServiceDisabledError;
                [self refreshViewOfCloseStops];
                break;
            default:
                break;
        }
    }
}

- (void) locationRetry {
//    NSLog( @"location retry" );
    positioningError = kNoPositionError;
    if ( locationManager_.locationServicesEnabled == YES ) {
        locationManager_.delegate = self;
        locationManager_.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // Set a movement threshold for new events
        locationManager_.distanceFilter = 100; 
        [locationManager_ stopMonitoringSignificantLocationChanges];
        [locationManager_ stopUpdatingLocation];
        [locationManager_ startUpdatingLocation];
//        NSLog( @"Loaded location manager" );
    } else {
        positioningError = kLocalisationServiceDisabledError;
        [self refreshViewOfCloseStops];
    }
}

- (void) locationStop {
//    NSLog( @"location stop" );
    [locationManager_ stopMonitoringSignificantLocationChanges];
    [locationManager_ stopUpdatingLocation];
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
        if ( closeStopsCount > 0 ) {
            return closeStopsCount;
        } else {
            return 1;
        }
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
    static NSString *CellIdentifierFav = @"CellFav";
    static NSString *CellIdentifierFavMore = @"CellFavMore";
    static NSString *CellIdentifierCloseStop = @"CellCloseStops";
    static NSString *CellIdentifierCloseStopError = @"CellCloseStopsError";
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
        if ( closeStopsCount > 0 ) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCloseStop];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifierCloseStop] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            // Configure the cell...
            Stop* stop = [closeStops objectAtIndex:indexPath.row];
            cell.textLabel.text = stop.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d m", stop.distance];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCloseStopError];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierCloseStopError] autorelease];
                UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                myButton.frame = CGRectMake(40, 20, 40, 30);
                myButton.accessibilityLabel = NSLocalizedString( @"Retenter", @"" );
                [myButton setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
                [myButton addTarget:self action:@selector(locationRetry) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = myButton;
            }
            // Configure the cell...
            cell.textLabel.text = NSLocalizedString( positioningErrorTexts[positioningError], @"" );
            cell.detailTextLabel.text = NSLocalizedString( positioningErrorDetails[positioningError], @"" );
        }
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
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFav];
                if( cell == nil ) {
                    cell = [[[FavTimeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFav] autorelease];
                }
                ((FavTimeViewCell*)cell).favorite = fav;
                ((FavTimeViewCell*)cell).times = times;
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
                if ( closeStopsCount > 0 ) {
                    stopMapViewController.originalPosition = locationManager_.location;
                }
                [self.navigationController pushViewController:stopMapViewController animated:YES];
                [stopMapViewController release];
            }
            break;
        case kFavoritesSection:
        {
            [self didSelectFavorite:indexPath];
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

- (void)didSelectFavorite:(NSIndexPath *)indexPath {
    int topCount = [topFavorites_ count];
    
    // any favorite at all
    if ( topCount > 0 ) {
        if ( indexPath.row < topCount ) {
            Favorite* fav = [topFavorites_ objectAtIndex:indexPath.row];
            if ( (NSArray*)[NSNull null] == [favoritesTimes_ objectAtIndex:indexPath.row] ) {
                // try to fix or remove it
                if ( [fav couldUpdateReferences] ) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Mise à jour"
                                                                    message:@"Ce favori a été mis à jour" 
                                                                   delegate:nil 
                                                          cancelButtonTitle:@"Ok" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                } else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Erreur", @"" )
                                                                    message:NSLocalizedString( @"Ce favori n'est plus valide", @"" )
                                                                   delegate:self 
                                                          cancelButtonTitle:NSLocalizedString( @"Annuler", @"" )
                                                          otherButtonTitles:NSLocalizedString( @"Supprimer", @"" ), nil];
                    [alert show];
                    [alert release];
                }
                return;
            }
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( 0 != buttonIndex) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        Favorite* fav = [topFavorites_ objectAtIndex:indexPath.row];
        [fav suicide];
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
    [closeStops release];
    [menus_ release];
    [super dealloc];
}


@end

