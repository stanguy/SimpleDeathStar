#import "StopTime.h"
#import "SimpleDeathStarAppDelegate.h"

@implementation StopTime

// Custom logic goes here.
+ (NSFetchedResultsController*) findByLine:(Line*) line andStop:(Stop*) stop{
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  managedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StopTime" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents =[gregorian components:unitFlags fromDate:now];
    
    // weekday 1 = Sunday for Gregorian calendar
    int weekday = [dateComponents weekday] - 2;
    if (weekday < 0) {
        weekday += 7;
    }
    int lcalendar = 1 << weekday ;
    [gregorian release];
    
    int min_arrival = ([dateComponents hour] * 60 + [dateComponents minute]) * 60 + [dateComponents second];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"line = %@ AND stop = %@ AND arrival > %@ AND calendar & %@ > 0", line, stop, [NSNumber numberWithInt:min_arrival], [NSNumber numberWithInt:lcalendar] ];
    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:2000];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"direction.headsign" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"arrival" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [NSFetchedResultsController deleteCacheWithName:@"StopTime"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"direction.headsign" cacheName:@"StopTime"];
    aFetchedResultsController.delegate = self;
    
    [predicate release];
    [fetchRequest release];
    [sortDescriptor2 release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    [aFetchedResultsController autorelease];
    
    return aFetchedResultsController;
}

@end
