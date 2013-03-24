#import "GTFSCalendar.h"

#import "GTFSCalendarDate.h"
#import "SimpleDeathStarAppDelegate.h"

extern NSDateComponents* dateToComponents( NSDate* date );

@interface GTFSCalendar ()

// Private interface goes here.

@end


@implementation GTFSCalendar

// Custom logic goes here.

+(NSArray*)calendarsAt:(NSDate*)t{
    NSArray* calendars = nil;
    
    NSDictionary* calendar_dates = [GTFSCalendarDate findExceptionsAt:t];
    NSPredicate* predicate = nil;
    
    int weekday = [dateToComponents( t ) weekday] - 2;
    if (weekday < 0) {
        weekday += 7;
    }
    NSInteger days = 1 << weekday;
    
    if ( [calendar_dates objectForKey:GTFSCalendarDateExclusions] && [calendar_dates objectForKey:GTFSCalendarDateInclusions] ) {
        predicate = [NSPredicate predicateWithFormat:@"( end_date >= %@ AND start_date <= %@ AND (days & %@ > 0) AND (NOT SELF IN %@) ) OR (SELF IN %@)", t, t, [NSNumber numberWithInt:days], [calendar_dates objectForKey:GTFSCalendarDateExclusions], [calendar_dates objectForKey:GTFSCalendarDateInclusions] ];
    } else if ( [calendar_dates objectForKey:GTFSCalendarDateExclusions] ) {
        predicate = [NSPredicate predicateWithFormat:@"( end_date >= %@ AND start_date <= %@ AND days & %@ > 0 AND (NOT SELF IN %@) )", t, t, [NSNumber numberWithInt:days], [calendar_dates objectForKey:GTFSCalendarDateExclusions] ];
    } else if ( [calendar_dates objectForKey:GTFSCalendarDateInclusions] ) {
        predicate = [NSPredicate predicateWithFormat:@"( end_date >= %@ AND start_date <= %@ AND days & %@ > 0 ) OR (SELF IN %@)", t, t, [NSNumber numberWithInt:days], [calendar_dates objectForKey:GTFSCalendarDateInclusions] ];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"end_date >= %@ AND start_date <= %@ AND days & %@ > 0", t, t, [NSNumber numberWithInt:days] ];
    }
    
    
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [self entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"days" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[sortDescriptor1 autorelease]];
    [fetchRequest setSortDescriptors:sortDescriptors];

    
    [fetchRequest setPredicate:predicate];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"_yyyy-MM-dd"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:[@"calendar" stringByAppendingString:[dateFormatter stringFromDate:t]]];
    [dateFormatter release];
    [fetchRequest release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    calendars = [aFetchedResultsController fetchedObjects];
    [aFetchedResultsController release];
    
    return calendars;
}



@end
