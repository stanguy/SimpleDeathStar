#import "SimpleDeathStarAppDelegate.h"
#import "StopAlias.h"

@implementation StopAlias

// Custom logic goes here.
+ (StopAlias*)findBySrcId:(NSString*)src_id {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [StopAlias entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"src_id = %@", src_id];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:1];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"src_id" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    [NSFetchedResultsController deleteCacheWithName:@"StopAlias"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    StopAlias* result = nil;
    if ( [[aFetchedResultsController fetchedObjects] count] > 0 ) {
        result = [[aFetchedResultsController fetchedObjects] objectAtIndex:0]; 
    }
    [aFetchedResultsController release];
    return result;
}

@end
