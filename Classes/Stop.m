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

+ (NSFetchedResultsController*) findAll{
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  managedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Stop entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = nil;
    if (nil != predicate) {
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
    
    if (predicate != nil) {
        [predicate release];
    }
    [fetchRequest release];
    [sortDescriptor2 release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    return aFetchedResultsController;
    
}
@end
