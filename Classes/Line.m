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
    NSManagedObjectContext* context = [delegate  managedObjectContext];
    
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
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"short_name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [NSFetchedResultsController deleteCacheWithName:@"Line"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"usage" cacheName:@"Line"];
    
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
