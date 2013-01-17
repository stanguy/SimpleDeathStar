//
//  Line.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "Line.h"
#import "SimpleDeathStarAppDelegate.h"

@implementation Line


+ (NSFetchedResultsController*)findAll:(int)type {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Line" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = nil;
    NSString* usage = nil;
    switch (type) {
        case LINE_USAGE_URBAN:
            usage = @"urban";
            break;
        case LINE_USAGE_SUBURBAN:
            usage = @"suburban";
            break;
        case LINE_USAGE_EXPRESS:
            usage = @"express";
            break;
        case LINE_USAGE_SPECIAL:
            usage = @"special";
            break;
        default:
            break;
    }
    if (nil != usage) {
        predicate = [NSPredicate predicateWithFormat:@"usage = %@", usage ];
        [fetchRequest setPredicate:predicate];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"usage" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"forced_id" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"short_name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, sortDescriptor3, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [NSFetchedResultsController deleteCacheWithName:@"Line"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"usage" cacheName:@"Line"];
    
    [fetchRequest release];
    [sortDescriptor3 release];
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

+ (Line*) findFirstBySrcId:(NSString*)src_id {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    return [self findFirstBySrcId:src_id inContext:context];
}

+ (Line*) findFirstBySrcId:(NSString*)src_id inContext:(NSManagedObjectContext*)context{
    if ( nil == src_id ) {
        return nil;
    }
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Line entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"src_id = %@", src_id ];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"src_id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString* cacheName = [NSString stringWithFormat:@"line_src_%@", src_id];
    
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
    Line* line = nil;
    if( [[aFetchedResultsController fetchedObjects] count] > 0 )
       line = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    [aFetchedResultsController release];
    return line;
}

+ (Line*) findByOldId:(NSString*)src_id {
    if ( nil == src_id ) {
        return nil;
    }
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  transitManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Line entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"old_src_id = %@", src_id ];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"old_src_id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString* cacheName = [NSString stringWithFormat:@"old_line_src_%@", src_id];
    
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
    Line* line = nil;
    if( [[aFetchedResultsController fetchedObjects] count] > 0 )
        line = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    [aFetchedResultsController release];
    return line;
}

@end
