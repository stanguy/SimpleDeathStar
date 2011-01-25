#import "Favorite.h"
#import "SimpleDeathStarAppDelegate.h"
#import "Stop.h"
#import "Line.h"

@implementation Favorite

// Custom logic goes here.

int kMaxTopFavorites = 5;

+ (Favorite*)fetchWithLine:(Line*)line andStop:(Stop*) stop{
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Favorite entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:1];
    
    NSPredicate* predicate ;
    if( line != nil ) {
        predicate = [NSPredicate predicateWithFormat:@"line_id = %@ AND stop_id = %@", line.src_id, stop.src_id ];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"line_id = nil AND stop_id = %@", stop.src_id ];
    }
    [fetchRequest setPredicate:predicate];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    [NSFetchedResultsController deleteCacheWithName:@"FavoriteExists"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"FavoriteExists"];
    
    [fetchRequest release];
    [sortDescriptor1 release];

    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    if ( [[aFetchedResultsController fetchedObjects] count] == 0 ) {
//        NSLog( @"no result" );
        return nil;
    }
    Favorite* fav = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    [aFetchedResultsController release];
    
    return fav;
}
+ (BOOL)existsWithLine:(Line*)line andStop:(Stop*) stop{
    Favorite* fav = [Favorite fetchWithLine:line andStop:stop];
    BOOL hasFavorite =  fav != nil;
    return hasFavorite;
}

+ (void)addWithLine:(Line*)line andStop:(Stop*) stop {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];
    Favorite* newFavorite = [Favorite insertInManagedObjectContext:context];
    if ( line != nil ) {
        newFavorite.line_short_name = line.short_name;
        newFavorite.line_id = line.src_id;
    }
    newFavorite.stop_name = stop.name;
    newFavorite.stop_id = stop.src_id;
    newFavorite.created_at = [NSDate date];
    NSError* error = nil;
    if ( ! [context save:&error] ) {
        NSLog( @"unsable to save" );
    }
}

+ (void)deleteWithLine:(Line*)line andStop:(Stop*) stop {   
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];

    Favorite* fav = [Favorite fetchWithLine:line andStop:stop];
    [context deleteObject:fav];
    
    NSError* error = nil;
    if ( ! [context save:&error] ) {
        NSLog( @"unsable to save" );
    }    
}

+ (int)count {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[Favorite entityInManagedObjectContext:context]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest: request error: &error];
    
    [request release];
    
    return count;
}

+ (NSArray*)topFavorites {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Favorite entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchLimit:kMaxTopFavorites];
        
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"view_count" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    [NSFetchedResultsController deleteCacheWithName:@"topFavorites"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"topFavorites"];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    NSArray* favs = [[aFetchedResultsController fetchedObjects] retain];
    [aFetchedResultsController release];
    return favs;
    
}

-(NSString*)title {
    if ( self.line_id != nil ) {
        return [NSString stringWithFormat:@"Ligne %@ à %@", self.line_short_name, self.stop_name];
    } else {
        return [NSString stringWithFormat:@"Arrêt %@", self.stop_name];
    }
}

@end
