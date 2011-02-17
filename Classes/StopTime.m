#import "StopTime.h"
#import "Favorite.h"
#import "Line.h"
#import "Stop.h"
#import "SimpleDeathStarAppDelegate.h"

@implementation StopTime


NSPredicate* buildPredicate( Line* line, Stop* stop, int min_arrival, int max_arrival, int calendar ) {
    NSPredicate* predicate;
    if (line != nil) {
        predicate = [NSPredicate predicateWithFormat:
                     @"line = %@ AND stop = %@ AND arrival > %@ AND arrival < %@ AND calendar & %@ > 0", line, stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:max_arrival], [NSNumber numberWithInt:calendar] ];
    } else {
        predicate = [NSPredicate predicateWithFormat:
                     @"stop = %@ AND arrival > %@ AND arrival < %@ AND calendar & %@ > 0", stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:max_arrival], [NSNumber numberWithInt:calendar] ];
    }
    return predicate;
}


// Custom logic goes here.
+ (NSFetchedResultsController*) findByLine:(Line*) line andStop:(Stop*) stop atDate:(NSDate*)date {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StopTime" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    
    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents =[gregorian components:unitFlags fromDate:date];
    NSPredicate *predicate ;
    int min_arrival = ([dateComponents hour] * 60 + [dateComponents minute]) * 60 + [dateComponents second];
    int max_arrival = min_arrival + BASE_TIMESHIFT;

    // weekday 1 = Sunday for Gregorian calendar
    int weekday = [dateComponents weekday] - 2;
    if (weekday < 0) {
        weekday += 7;
    }
    int lcalendar = 1 << weekday ;
    [gregorian release];
    predicate = buildPredicate( line, stop, min_arrival, max_arrival, lcalendar );
    
    if ( [dateComponents hour] < 8 ) {
        weekday = ( weekday + 6 ) % 7;
        lcalendar = 1 << weekday ;
        min_arrival = min_arrival + 24 * 60 * 60;
        max_arrival = max_arrival + 24 * 60 * 60;
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate, buildPredicate( line, stop, min_arrival, max_arrival, lcalendar ), nil]];
    }
    

    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"direction" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"arrival" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [NSFetchedResultsController deleteCacheWithName:@"StopTime"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"direction" cacheName:@"StopTime"];
    aFetchedResultsController.delegate = self;
    
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
    [aFetchedResultsController autorelease];
    
    return aFetchedResultsController;
}


// Custom logic goes here.
+ (NSFetchedResultsController*) findFollowing:(StopTime*)stopTime {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StopTime" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"stop"]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:
                 @"trip_id = %@ AND arrival >= %@", stopTime.trip_id, stopTime.arrival];

    
    
    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"arrival" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [NSFetchedResultsController deleteCacheWithName:@"StopTimeFollowing"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"StopTimeFollowing"];
    
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    [aFetchedResultsController autorelease];
    
    return aFetchedResultsController;
}

+ (NSArray*) findComingAt:(Favorite*)favorite {
    Line* line = ( favorite.line_id != nil ) ? [Line findFirstBySrcId:favorite.line_id] : nil;
    Stop* stop = [Stop findFirstBySrcId:favorite.stop_id];

    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [StopTime entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    NSDate* date = [NSDate date];
    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents =[gregorian components:unitFlags fromDate:date];
    int min_arrival = ([dateComponents hour] * 60 + [dateComponents minute]) * 60 + [dateComponents second];
    int max_arrival = min_arrival + BASE_TIMESHIFT;
    
    // weekday 1 = Sunday for Gregorian calendar
    int weekday = [dateComponents weekday] - 2;
    if (weekday < 0) {
        weekday += 7;
    }
    int lcalendar = 1 << weekday ;
    
    NSPredicate* predicate = buildPredicate( line, stop, min_arrival, max_arrival, lcalendar );
    if ( [dateComponents hour] < 8 ) {
        weekday = ( weekday + 6 ) % 7;
        lcalendar = 1 << weekday ;
        min_arrival = min_arrival + 24 * 60 * 60;
        max_arrival = min_arrival + BASE_TIMESHIFT;
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:buildPredicate( line, stop, min_arrival, max_arrival, lcalendar ), predicate, nil]];
    }
    
    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchLimit:4];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"arrival" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    [gregorian release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    NSArray* stopTimes = [aFetchedResultsController fetchedObjects];
    [aFetchedResultsController release];
    return stopTimes;
}

- (NSString*) formatArrival{
    int arrival = [self.arrival intValue] / 60;
    int mins = arrival % 60;
    int hours = ( arrival / 60 ) % 24;
    return [NSString stringWithFormat:@"%02d:%02d", hours, mins]; 
}

@end
