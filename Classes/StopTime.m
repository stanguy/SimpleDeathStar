#import "StopTime.h"
#import "Favorite.h"
#import "Line.h"
#import "Stop.h"
#import "SimpleDeathStarAppDelegate.h"

@implementation StopTime

/*
 Thanks, Yan!
 % perl -e 'while(<>) { next unless /joursFeries\.add\("(\d\d)(\d\d)(\d{4})"/ ; print $3 . $2 . $1 . ",\n" ; }' < JoursFeries.java
 */
int HOLIDAYS[] = {
    20101225,
    20110101,
    20110425,
    20110501,
    20110508,
    20110602,
    20110613,
    20110714,
    20110815,
    20111101,
    20111111,
    20111225,
    20120101,
    20120409,
    20120501,
    20120508,
    20120517,
    20120528,
    20120714,
    20120815,
    20121101,
    20121111,
    20121225,
    20130101,
    20130401,
    20130501,
    20130508,
    20130509,
    20130519,
    20130714,
    20130815,
    20131101,
    20131111,
    20131225,
    0 // sentinel
};

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

NSPredicate* buildPredicate( Line* line, Stop* stop, int min_arrival, int max_arrival, NSDateComponents* dateComponents ) {
    NSPredicate* predicate = nil;
    
    NSString* lineStrPred, *stopStrPred;
    if ( ((SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate]).useArrival ) {
        lineStrPred = @"line = %@ AND stop = %@ AND arrival > %@ AND arrival < %@ AND calendar & %@ > 0";
        stopStrPred = @"stop = %@ AND arrival > %@ AND arrival < %@ AND calendar & %@ > 0";
    } else {
        lineStrPred = @"line = %@ AND stop = %@ AND departure > %@ AND departure < %@ AND calendar & %@ > 0";
        stopStrPred = @"stop = %@ AND departure > %@ AND departure < %@ AND calendar & %@ > 0";
    }

    
    // weekday 1 = Sunday for Gregorian calendar
    int weekday = [dateComponents weekday] - 2;
    if (weekday < 0) {
        weekday += 7;
    }
    
    int month = [dateComponents month];
    int day = [dateComponents day];
    int year = [dateComponents year];
    
    if ( month == 5 && day == 1 ) {
        // there is no bus on May 1st
        predicate = [NSPredicate predicateWithFormat:@"FALSEPREDICATE"];
        return predicate;
    } else {
        // holiday: like a sunday
        int holiday = ( ( year * 100 ) + month ) * 100 + day;
        int* ph = HOLIDAYS;
        // look Ma'! Hairy C!
        while ( *ph && *ph != holiday ) {
            ++ph;
        }
        if ( *ph ) {
            weekday = 6;
        }
    }
    int calendar = 1 << weekday ;

    if (line != nil) {
        predicate = [NSPredicate predicateWithFormat:
                     lineStrPred, line, stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:max_arrival], [NSNumber numberWithInt:calendar] ];
    } else {
        predicate = [NSPredicate predicateWithFormat:
                     stopStrPred, stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:max_arrival], [NSNumber numberWithInt:calendar] ];
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

    predicate = buildPredicate( line, stop, min_arrival, max_arrival, dateComponents );
    
    if ( [dateComponents hour] < 8 ) {
        NSDate* datePrevDay = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
        NSDateComponents* prevDateComponents = dateToComponents( datePrevDay );
        min_arrival = min_arrival + 24 * 60 * 60;
        max_arrival = max_arrival + 24 * 60 * 60;
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate, buildPredicate( line, stop, min_arrival, max_arrival, prevDateComponents ), nil]];
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
    
    NSPredicate* predicate;
    if ( ((SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate]).useArrival ) {
        predicate =[NSPredicate predicateWithFormat:
                 @"trip_id = %@ AND arrival >= %@", stopTime.trip_id, stopTime.arrival];
    } else {
        predicate =[NSPredicate predicateWithFormat:
                    @"trip_id = %@ AND departure >= %@", stopTime.trip_id, stopTime.departure];
        
    }
    
    
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
    
    if ( nil == stop || ( favorite.line_id != nil && line == nil ) ) {
        NSLog( @"nil favorite in fav!" );
        return (NSArray*)[NSNull null];
    }

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
    
    
    NSPredicate* predicate = buildPredicate( line, stop, min_arrival, max_arrival, dateComponents );
    if ( [dateComponents hour] < 8 ) {
        NSDate* datePrevDay = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
        NSDateComponents* prevDateComponents = dateToComponents( datePrevDay );
        min_arrival = min_arrival + 24 * 60 * 60;
        max_arrival = min_arrival + BASE_TIMESHIFT;
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:buildPredicate( line, stop, min_arrival, max_arrival, prevDateComponents ), predicate, nil]];
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
    aFetchedResultsController.delegate = self;
    
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

- (NSString*) formatArrival{
    NSNumber* dbvalue;
    if ( ((SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate]).useArrival ) {
        dbvalue = self.arrival;
    } else {
        dbvalue = self.departure;
    }
    int arrival = [dbvalue intValue] / 60;
    int mins = arrival % 60;
    int hours = ( arrival / 60 ) % 24;
    return [NSString stringWithFormat:@"%02d:%02d", hours, mins]; 
}

@end
