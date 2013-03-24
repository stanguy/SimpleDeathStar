#import "StopTime.h"
#import "Favorite.h"
#import "GTFSCalendar.h"
#import "Line.h"
#import "Stop.h"
#import "SimpleDeathStarAppDelegate.h"

@implementation StopTime


NSString* sortKey(){
    if ( ((SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate]).useArrival ) {
        return @"arrival";
    } else {
        return @"departure";
    }
}

NSDateComponents* dateToComponents( NSDate* date ) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    
    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *dateComponents =[gregorian components:unitFlags fromDate:date];
    [gregorian release];
    return dateComponents;
}

NSPredicate* buildPredicate( Line* line, Stop* stop, int min_arrival, int max_arrival, NSDate* date ) {
    NSPredicate* predicate = nil;
    
    NSString* lineStrPred, *stopStrPred;
    if ( ((SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate]).useArrival ) {
        lineStrPred = @"line = %@ AND stop = %@ AND arrival > %@ AND arrival < %@ AND calendar IN %@";
        stopStrPred = @"stop = %@ AND arrival > %@ AND arrival < %@ AND calendar IN %@";
    } else {
        lineStrPred = @"line = %@ AND stop = %@ AND departure > %@ AND departure < %@ AND calendar IN %@";
        stopStrPred = @"stop = %@ AND departure > %@ AND departure < %@ AND calendar IN %@ ";
    }

    NSArray* calendars = [GTFSCalendar calendarsAt:date];
    
    if (line != nil) {
        predicate = [NSPredicate predicateWithFormat:
                     lineStrPred, line, stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:max_arrival], calendars ];
    } else {
        predicate = [NSPredicate predicateWithFormat:
                     stopStrPred, stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:max_arrival], calendars ];
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
    
    NSPredicate *predicate ;
    NSDateComponents* dateComponents = dateToComponents( date );
    int min_arrival = ([dateComponents hour] * 60 + [dateComponents minute]) * 60 + [dateComponents second];
    int max_arrival = min_arrival + BASE_TIMESHIFT;

    predicate = buildPredicate( line, stop, min_arrival, max_arrival, date );
    
    if ( [dateComponents hour] < 8 ) {
        NSDate* datePrevDay = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
        min_arrival = min_arrival + 24 * 60 * 60;
        max_arrival = max_arrival + 24 * 60 * 60;
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate, buildPredicate( line, stop, min_arrival, max_arrival, datePrevDay ), nil]];
    }
    

    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"direction" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:sortKey() ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [NSFetchedResultsController deleteCacheWithName:@"StopTime"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"direction" cacheName:@"StopTime"];
    
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
    
    NSPredicate* predicate;
    predicate =[NSPredicate predicateWithFormat:
                 @"trip_id = %@ AND stop_sequence >= %@", stopTime.trip_id, stopTime.stop_sequence];
    
    
    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stop_sequence" ascending:YES];
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
    
    if ( nil == stop || ( favorite.line_id != nil && line == nil ) ) {
        NSLog( @"nil favorite in fav!" );
        return (NSArray*)[NSNull null];
    }
    return [self findComingAtStop:stop andLine:line];
}

+ (NSArray*) findComingAtStop:(Stop*)stop andLine:(Line*)line {
    
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [StopTime entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSDate* date = [NSDate date];
    NSDateComponents *dateComponents = dateToComponents( date );
    int min_arrival = ([dateComponents hour] * 60 + [dateComponents minute]) * 60 + [dateComponents second];
    int max_arrival = min_arrival + BASE_TIMESHIFT;
    
    
    NSPredicate* predicate = buildPredicate( line, stop, min_arrival, max_arrival, date );
    if ( [dateComponents hour] < 8 ) {
        NSDate* datePrevDay = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
        min_arrival = min_arrival + 24 * 60 * 60;
        max_arrival = min_arrival + BASE_TIMESHIFT;
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:buildPredicate( line, stop, min_arrival, max_arrival, datePrevDay ), predicate, nil]];
    }
    
    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchLimit:4];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:sortKey() ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
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

-(BOOL)canDistinguistArrivalAndDeparture {
    return YES;
}

-(NSString*)format:(NSNumber*)datetime relativeTo:(NSDate*)relative_date {
    int arrival = [datetime intValue] / 60;
    if ( relative_date != nil ) {        
        NSDateComponents *dateComponents = dateToComponents( relative_date );
        int reft = [dateComponents hour] * 60 + [dateComponents minute];
        if ( arrival > 24 * 60 ) {
            if ( reft < 12 * 60 ) {
                reft = reft + 24*60;
            }
        }
        return [NSString stringWithFormat:@"%d", arrival - reft];
    } else {
        int mins = arrival % 60;
        int hours = ( arrival / 60 ) % 24;
        return [NSString stringWithFormat:@"%02d:%02d", hours, mins];
    }

}

-(NSString*)departure:(NSDate *)relative_date{
    return [self format:self.departure relativeTo:relative_date];
}
-(NSString*)arrival:(NSDate *)relative_date {
    return [self format:self.arrival relativeTo:relative_date];
    
}


@end
