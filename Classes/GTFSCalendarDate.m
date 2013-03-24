#import "GTFSCalendarDate.h"
#import "SimpleDeathStarAppDelegate.h"

NSString* GTFSCalendarDateExclusions = @"exclusions",
        * GTFSCalendarDateInclusions = @"inclusions";

extern NSDateComponents* dateToComponents( NSDate* date );

@interface GTFSCalendarDate ()

// Private interface goes here.

@end


@implementation GTFSCalendarDate

// Custom logic goes here.
+(NSDictionary*)findExceptionsAt:(NSDate*)date
{
    NSMutableDictionary* results = [NSMutableDictionary dictionaryWithCapacity:2];
    
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [self entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1;
    sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"is_exclusion" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:date]; // gets the year, month, and day for today's date
    NSDate *lower = [gregorian dateFromComponents:components]; // makes a new NSDate keeping only the year, month, and day
    NSDate* upper = [lower dateByAddingTimeInterval:86400];
    [gregorian release];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"exception_date >= %@ AND exception_date < %@", lower, upper];
    
    [fetchRequest setPredicate:predicate];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"_yyyy-MM-dd"];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:[@"calendar_dates" stringByAppendingString:[dateFormatter stringFromDate:lower]]];
    [dateFormatter release];
    [fetchRequest release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    NSArray* dates = [aFetchedResultsController fetchedObjects];
    
    NSMutableArray* exclusions = [NSMutableArray arrayWithCapacity:[dates count]];
    NSMutableArray* inclusions = [NSMutableArray arrayWithCapacity:[dates count]];
    for ( GTFSCalendarDate* gtfsdate in dates ) {
        if ( gtfsdate.is_exclusionValue ) {
            [exclusions addObject:gtfsdate.calendar];
        } else {
            [inclusions addObject:gtfsdate.calendar];
        }
    }
    if ( [exclusions count] > 0 ) {
        [results setObject:exclusions forKey:GTFSCalendarDateExclusions];
    }
    if ( [inclusions count] > 0 ) {
        [results setObject:inclusions forKey:GTFSCalendarDateInclusions];
    }
    [aFetchedResultsController release];
    
    return results;
}

@end
