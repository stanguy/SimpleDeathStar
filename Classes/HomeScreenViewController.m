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
#import "FavTimeRelativeViewCell.h"


@interface HomeScreenViewController ()
-(void)refreshViewOfCloseStops;
@end

@implementation HomeScreenViewController

#ifdef VERSION_STLO
NSString* menuTitles[] = {
    @"Favoris",
    @"Arrêts proches",
    @"Lignes",
    @"Recherche par arrêt",
    @""
};
enum eSections {
    kFavoritesSection,
    kCloseStopsSection,
    kLineSection,
    kStopsSection,
    kAboutSection
};
#else

NSString* menuTitles[] = {
    @"Recherche par lignes",
    @"Recherche par arrêt",
    @"Favoris",
    @"Arrêts proches",
    @""
};
enum eSections {
    kLineSection,
    kStopsSection,
    kFavoritesSection,
    kCloseStopsSection,
    kAboutSection
};

int LineMenuValues[] = {
    LINE_USAGE_URBAN,
    LINE_USAGE_SUBURBAN,
    LINE_USAGE_EXPRESS,
    LINE_USAGE_SPECIAL,
    LINE_USAGE_ALL,
    -1
};
#endif
@synthesize locationManager = locationManager_;

int AboutMenuValues[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    ABOUT_ONLINE,
    -1
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

-(id)init {
    self = [super init];
    if ( self ) {
        
    }
    return self;
}

- (UITableViewStyle)defaultStyle {
    return UITableViewStyleGrouped;
}

#pragma mark View lifecycle


-(void)refreshViewOfFavorites {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kFavoritesSection] withRowAnimation:YES];
}

- (void)reloadFavorites {
    NSArray* favorites = [[Favorite topFavorites] retain];
    NSMutableArray* favtimes = [[NSMutableArray alloc] initWithCapacity:[favorites count]];
    for ( Favorite* fav in favorites ) {
        [favtimes addObject:[StopTime findComingAt:fav]];
    }
    [favoritesTimes_ release];
    favoritesTimes_ = [favtimes retain];
    cachedFavoritesCount = [Favorite count];
    NSArray* oldFavorites = topFavorites_;
    topFavorites_ = favorites;
    [oldFavorites release];
    [self refreshViewOfFavorites];
}

- (void)reloadProximity {
    NSMutableArray* proxtimes = [[NSMutableArray alloc] initWithCapacity:[closeStops count]];
    for ( Stop* stop in closeStops ) {
        [proxtimes addObject:[StopTime findComingAtStop:stop andLine:nil]];
    }
    [proximityTimes_ release];
    proximityTimes_ = [proxtimes retain];
    [self refreshViewOfCloseStops];
}


-(void)reloadByTimer {
    [self reloadFavorites];
    [self reloadProximity];
}


-(void)refreshViewOfCloseStops {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kCloseStopsSection] withRowAnimation:YES];
}


-(void)finishReloadCloseStops:(NSArray*)thr_stops {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate transitManagedObjectContext];
    NSMutableArray* stops = [NSMutableArray arrayWithCapacity:[thr_stops count]];
    for( Stop* stop in thr_stops ) {
        Stop* correct_stop = (Stop*) [context objectWithID:[stop objectID]];
        correct_stop.distance = stop.distance;
        [stops addObject:correct_stop];
    }
    [closeStops release];
    closeStops = [stops retain];
    closeStopsCount = [stops count];
    [self reloadProximity];
    
}

-(void)runReloadCloseStops:(CLLocation*)location {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    [context setPersistentStoreCoordinator:[delegate transitPersistentStoreCoordinator]];
    NSArray* stops = [Stop findAroundLocation:location withinContext:context];
    [self performSelectorOnMainThread:@selector(finishReloadCloseStops:) withObject:stops waitUntilDone:YES];
    [context release];
    [pool release];
}

- (void)reloadCloseStops:(CLLocation*)location{
    [self performSelectorInBackground:@selector(runReloadCloseStops:) withObject:location];
}

- (void)callFavLoading {
    [self reloadFavorites];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString( @"Accueil", @"" );
    menus_ = [[NSMutableArray alloc] init];
#ifdef VERSION_STLO
    lines = [[[Line findAll:LINE_USAGE_ALL] fetchedObjects] retain]; 
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects: NSLocalizedString( @"Tous les arrêts", @"" ), NSLocalizedString( @"Sur la carte", @""), nil]];
    [menus_ addObject:[NSArray arrayWithObjects: NSLocalizedString( @"À propos", @"" ), NSLocalizedString( @"Pas de panique", @"" ), nil ]];
#else
    NSArray* linesMenu = [NSArray arrayWithObjects:NSLocalizedString( @"Lignes urbaines", @""), 
                          NSLocalizedString( @"Lignes suburbaines", @""), 
                          NSLocalizedString( @"Lignes express", @""), 
                          NSLocalizedString( @"Lignes spéciales", @""), 
                          NSLocalizedString( @"Toutes les lignes", @""), /*@"Favorites",*/ nil ];
    [menus_ addObject:linesMenu];
    [menus_ addObject:[NSArray arrayWithObjects: NSLocalizedString( @"Arrêts par ville", @"" ), NSLocalizedString( @"Tous les arrêts", @"" ), NSLocalizedString( @"Sur la carte", @""), nil]];
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects: NSLocalizedString( @"À propos", @"" ), NSLocalizedString( @"Pas de panique", @"" ), NSLocalizedString( @"En ligne", @"" ), nil ]];
#endif
    favoritesTimes_ = [[NSMutableArray alloc] init];
    proximityTimes_ = [[NSMutableArray alloc] init];
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



#pragma mark -
#pragma mark CoreLocation stuff


BOOL checkBounds( CLLocation* location ) {
#ifndef VERSION_STLO
    const double N = 48.32;
    const double W = -2.02;
    const double S = 47.9;
    const double E = -1.3;
#else
    const double N = 49.17;
    const double W = -1.22;
    const double S = 49.05;
    const double E = -0.9;
#endif
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    return ( ( latitude < N ) && ( latitude > S ) && ( longitude > W ) && ( longitude < E ) );
}

- (void)commitLocationUpdate {
    CLLocation* newLocation = locationManager_.location;
    if ( checkBounds( newLocation ) ) {
        [self reloadCloseStops:newLocation];
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
    if ( [CLLocationManager locationServicesEnabled] ) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == kFavoritesSection || indexPath.section == kCloseStopsSection ) {
        return 60.0f;
    } else {
        return 44.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
#ifdef VERSION_STLO
    if ( section != kFavoritesSection && section != kLineSection && section != kCloseStopsSection) {
        return [[menus_ objectAtIndex:section] count];
    } else if ( section == kLineSection ) {
        return [lines count];
    } else if ( section == kCloseStopsSection ) {
        if ( closeStopsCount > 0 ) {
            return closeStopsCount;
        } else {
            return 1;
        }
#else
    if ( section != kFavoritesSection && section != kCloseStopsSection ) {
        return [[menus_ objectAtIndex:section] count];
    } else if ( section == kCloseStopsSection ) {
        if ( closeStopsCount > 0 ) {
            return closeStopsCount;
        } else {
            return 1;
        }
#endif
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
    
int hexCharToInt( char c ) {
    if ( isdigit(c)) {
        return c - '0';
    } else {
        return 10 + (tolower(c) - 'a');
    }
}
float hexToFloatColor( char c1, char c2 ) {    
    return (hexCharToInt(c1) * 16 + hexCharToInt(c2)) / 256.0;
}
    

#ifdef VERSION_STLO
    
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == kLineSection ) {
        Line* line = [lines objectAtIndex:indexPath.row];
        const char* bgcolor = [line.bgcolor UTF8String];
        if ( bgcolor != NULL ) {        
            UIColor* color = [UIColor colorWithRed:hexToFloatColor(bgcolor[1], bgcolor[2]) 
                                             green:hexToFloatColor(bgcolor[3], bgcolor[4]) 
                                              blue:hexToFloatColor(bgcolor[5], bgcolor[6]) 
                                             alpha:1];
            cell.textLabel.backgroundColor = color;
        }
        const char* fgcolor = [line.fgcolor UTF8String];
        if ( fgcolor != NULL ) {        
            UIColor* color = [UIColor colorWithRed:hexToFloatColor(fgcolor[1], fgcolor[2]) 
                                             green:hexToFloatColor(fgcolor[3], fgcolor[4]) 
                                              blue:hexToFloatColor(fgcolor[5], fgcolor[6]) 
                                             alpha:1];
            cell.textLabel.textColor = color;
        }
    }
}
#endif
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class favClass;
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (  [delegate useRelativeTime] ) {
        favClass = [FavTimeRelativeViewCell class];
    } else {
        favClass = [FavTimeViewCell class];
    }
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierLine = @"Line";
    static NSString *CellIdentifierFavNone = @"CellFavNone";
    static NSString *CellIdentifierFav = @"CellFav";
    static NSString *CellIdentifierFavMore = @"CellFavMore";
    static NSString *CellIdentifierCloseStop = @"CellCloseStops";
    static NSString *CellIdentifierCloseStopError = @"CellCloseStopsError";
    UITableViewCell *cell = nil;
#ifdef VERSION_STLO
    if ( indexPath.section == kLineSection ) {
        Line* line = [lines objectAtIndex:indexPath.row];
        NSString* cellIdentifierParticularLine = [CellIdentifierLine stringByAppendingString:line.src_id];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierParticularLine ];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierParticularLine] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        // Configure the cell...
        cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString( @"Ligne %@", @"" ), line.short_name];
        cell.detailTextLabel.text = line.long_name;

        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [cell.textLabel sizeToFit];
        CGRect frame = cell.frame;
        frame.size.width += 120;
        cell.frame = frame;
        
    } else if ( indexPath.section != kFavoritesSection && indexPath.section != kCloseStopsSection ) {
#else
    if ( indexPath.section != kFavoritesSection && indexPath.section != kCloseStopsSection ) {
#endif
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    // Configure the cell...
        cell.textLabel.text = [[menus_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else if ( indexPath.section == kCloseStopsSection ) {
        if ( closeStopsCount > 0 ) {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d m", stop.distance];

        
            NSArray* times = nil;
            times = [proximityTimes_ objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCloseStop];
            if( cell == nil ) {
                cell = [[[favClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierCloseStop] autorelease];
            }
            Stop* stop = [closeStops objectAtIndex:indexPath.row];
            ((FavTimeViewCell*)cell).times = times;
            ((FavTimeViewCell*)cell).stop = stop;
        
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
                    cell = [[[favClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFav] autorelease];
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
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    // Navigation logic may go here. Create and push another view controller.
    switch ( indexPath.section) {
        case kLineSection:
#ifdef VERSION_STLO
        {
            StopViewController* stopViewController = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
            stopViewController.line = [lines objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:stopViewController animated:YES];
            [stopViewController release];            
        }
#else
            if ( LineMenuValues[indexPath.row] > 0 ) {
                LineViewController* lineViewController = [[LineViewController alloc] init];
                lineViewController.usageType = LineMenuValues[indexPath.row];
                [self.navigationController pushViewController:lineViewController animated:YES];
                [lineViewController release];
            }
#endif
            break;
        case kStopsSection:
            
#ifdef VERSION_STLO
        {
            if ( indexPath.row == 0 ) {
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
        }
#else
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
#endif
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
            AboutViewController* aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            aboutVC.type = AboutMenuValues[indexPath.row];
            [self.navigationController pushViewController:aboutVC animated:YES];
            [aboutVC release];
            
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Mise à jour", @"" )
                                                                    message:NSLocalizedString( @"Ce favori a été mis à jour", @"" )
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
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
    [proximityTimes_ release];
    [favoritesTimes_ release];
    [closeStops release];
    [menus_ release];
    [super dealloc];
}


@end

