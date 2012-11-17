//
//  CloseStopsHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "CloseStopsHomeSection.h"

#import "FavTimeRelativeViewCell.h"
#import "FavTimeViewCell.h"
#import "SimpleDeathStarAppDelegate.h"
#import "Stop.h"
#import "StopTime.h"
#import "StopTimeViewController.h"

@implementation CloseStopsHomeSection

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

@synthesize closeStops, locationManager, proximityTimes;

-(NSString*)title{
    return @"Arrêts proches";
}

-(id)init {
    self = [super init];
    closeStops = nil;
    locationManager = [[CLLocationManager alloc] init];
    [self locationRetry];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationRetry) name:@"locationRetry" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationStop) name:@"locationStop" object:nil];
    currentDelay = 1;
    lastUpdate = 0;
    return self;
}

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    if ( closeStopsCount > 0 ) {
        StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
        stoptimeView.stop = [closeStops objectAtIndex:row];
        [controller.navigationController pushViewController:stoptimeView animated:YES];
        [stoptimeView release];
    }
}

- (void) locationRetry {
    //    NSLog( @"location retry" );
    positioningError = kNoPositionError;
    if ( [CLLocationManager locationServicesEnabled] ) {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // Set a movement threshold for new events
        locationManager.distanceFilter = 100;
        [locationManager stopMonitoringSignificantLocationChanges];
        [locationManager stopUpdatingLocation];
        [locationManager startUpdatingLocation];
        //        NSLog( @"Loaded location manager" );
    } else {
        positioningError = kLocalisationServiceDisabledError;
        //        [self refreshViewOfCloseStops];
    }
}

- (void) locationStop {
    //    NSLog( @"location stop" );
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
}


- (NSInteger)numberOfElements{
    if ( closeStopsCount > 0 ) {
        return closeStopsCount;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifierCloseStop = @"CellCloseStops";
    static NSString *CellIdentifierCloseStopError = @"CellCloseStopsError";
    UITableViewCell *cell = nil;
    
    Class favClass;
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (  [delegate useRelativeTime] ) {
        favClass = [FavTimeRelativeViewCell class];
    } else {
        favClass = [FavTimeViewCell class];
    }

    
    if ( closeStopsCount > 0 ) {
        //            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d m", stop.distance];
        
        
        NSArray* times = nil;
        times = [self.proximityTimes objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCloseStop];
        if( cell == nil ) {
            cell = [[[favClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierCloseStop] autorelease];
        }
        Stop* stop = [self.closeStops objectAtIndex:indexPath.row];
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
    return cell;
}

- (void)reloadByTimer {
    [self reloadProximity];
}

-(void)refreshViewOfCloseStops {
    [self.delegate reloadSection:self];
}

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


- (void)commitLocationUpdate {
    CLLocation* newLocation = locationManager.location;
    if ( checkBounds( newLocation ) ) {
        [self reloadCloseStops:newLocation];
    } else {
        positioningError = kOutOfBoundsPositionError;
        [self refreshViewOfCloseStops];
    }
    [locationManager stopUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
}

#pragma -
#pragma CoreLocation stuff

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@ (%d)", [newLocation description], abs( [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp] ) );
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(commitLocationUpdate) object:nil];
    
    time_t now = time( NULL );
    if ( ( now - lastUpdate ) < 10 ) {
        NSLog( @"delaying update" );
        currentDelay = currentDelay * 2;
    } else {
        NSLog( @"reseting update" );
        currentDelay = 1;
    }
    lastUpdate = now;
    [self performSelector:@selector(commitLocationUpdate) withObject:nil afterDelay:currentDelay];
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

- (CGFloat)rowHeight {
    return 60.0f;
}

- (void)reloadProximity {
    NSMutableArray* proxtimes = [[NSMutableArray alloc] initWithCapacity:[closeStops count]];
    for ( Stop* stop in closeStops ) {
        [proxtimes addObject:[StopTime findComingAtStop:stop andLine:nil]];
    }
    proximityTimes = [proxtimes retain];
    [self refreshViewOfCloseStops];
}


@end
