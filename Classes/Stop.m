//
//  Stop.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "Stop.h"
#import "SimpleDeathStarAppDelegate.h"


@implementation Stop

@synthesize distance = distance_;

+ (NSFetchedResultsController*) findAll{
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Stop entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"city.name" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [NSFetchedResultsController deleteCacheWithName:@"Stop"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"city.name" cacheName:@"Stop"];
    
    [fetchRequest release];
    [sortDescriptor2 release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    return [aFetchedResultsController autorelease];
    
}

+ (NSFetchedResultsController*) findByName:(NSString*) text {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Stop entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = nil;
    if (nil != text) {
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
        [fetchRequest setPredicate:predicate];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"city.name" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [NSFetchedResultsController deleteCacheWithName:@"Stop"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"city.name" cacheName:@"Stop"];
    
    [fetchRequest release];
    [sortDescriptor2 release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    return [aFetchedResultsController autorelease];
    
}
+ (Stop*) findFirstBySrcId:(NSString*)src_id {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Stop entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"src_id = %@", src_id ];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"src_id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString* cacheName = [NSString stringWithFormat:@"stop_src_%@", src_id];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    Stop* stop = nil;
    if( [[aFetchedResultsController fetchedObjects] count] > 0 )
        stop = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    [aFetchedResultsController release];
    return stop;
}

- (int) allCounts{
    return [self.pos_count intValue] + [self.bike_count intValue] + [self.metro_count intValue];
}


+ (NSArray*) findAroundLocation:(CLLocationCoordinate2D)location withRadius:(float)radius {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Stop entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSNumber* N = [NSNumber numberWithDouble:(location.latitude + radius)];
    NSNumber* S = [NSNumber numberWithDouble:(location.latitude - radius)];
    NSNumber* W = [NSNumber numberWithDouble:(location.longitude - radius)];
    NSNumber* E = [NSNumber numberWithDouble:(location.longitude + radius)];
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"lat > %@ AND lat < %@ AND lon > %@ AND lon < %@",
                              S, N, W, E ];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"src_id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString* cacheName = @"stop_by_location";
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    NSArray* stops = [aFetchedResultsController fetchedObjects];
    [aFetchedResultsController release];
    return stops;
}


+ (NSArray*) findAroundLocation:(CLLocation*)location{
    NSArray* result = nil;
    float radius = 0.0001;
    int previous_count = 0;
//    NSLog( @"findAroundLocation" );
    do {
        result = [Stop findAroundLocation:location.coordinate withRadius:radius];
        if ([result count] > previous_count ) {
            radius *= 2;
        } else {
            radius *= 5;
        }
        previous_count = [result count];
//        NSLog( @"found %d stops in a radius of %f", previous_count, radius );
    } while ( result != nil && previous_count < 5 );
    for( Stop* stop in result ) {
        CLLocation* stopLocation = [[CLLocation alloc] initWithLatitude:[stop.lat doubleValue] longitude:[stop.lon doubleValue]];
        stop.distance = (int) [location distanceFromLocation:stopLocation];
        [stopLocation release];
    }
    NSArray* sortedResult = [result sortedArrayUsingComparator:^(id a, id b) {
        int ad = ((Stop*)a).distance;
        int bd = ((Stop*)b).distance;
        if ( ad > bd ) { return (NSComparisonResult)NSOrderedDescending; }
        if ( ad < bd ) { return (NSComparisonResult)NSOrderedAscending; }
        return (NSComparisonResult)NSOrderedSame;
    }];
    if ( previous_count > 5 ) {
        NSRange r;
        r.location = 0;
        r.length = 5;
        sortedResult = [sortedResult subarrayWithRange:r];
    }
    return sortedResult;
}

+ (Stop*) findFirstBySlug:(NSString*)slug {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Stop entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"slug = %@", slug ];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"slug" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString* cacheName = [NSString stringWithFormat:@"stop_slug_%@", slug];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    Stop* stop = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    [aFetchedResultsController release];
    return stop;
}

+ (NSArray*) findFromPosition:(CLLocationCoordinate2D)center 
            withLatitudeDelta:(CLLocationDegrees)latitudeDelta 
            andLongitudeDelta:(CLLocationDegrees)longitudeDelta
{
    double radius = MAX( latitudeDelta, longitudeDelta ) / 2;
    return [Stop findAroundLocation:center withRadius:radius];
}


@end
