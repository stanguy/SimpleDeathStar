#import "Favorite.h"
#import "SimpleDeathStarAppDelegate.h"
#import "Stop.h"
#import "StopAlias.h"
#import "Line.h"

@implementation Favorite

// Custom logic goes here.

int kMaxTopFavorites = 5;
+ (Favorite*)fetchWithLine:(Line*)line andStop:(Stop*) stop {
    return [Favorite fetchWithLine:line andStop:stop inContext:nil];
}
+ (Favorite*)fetchWithLine:(Line*)line andStop:(Stop*) stop inContext:(NSManagedObjectContext*)context_{
    NSManagedObjectContext* context = context_;
    if ( nil == context ) {
        SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
        context = [delegate  userManagedObjectContext];
    }
    
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
    [sortDescriptors release];

    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    if ( [[aFetchedResultsController fetchedObjects] count] == 0 ) {
//        NSLog( @"no result" );
        [aFetchedResultsController release];
        return nil;
    }
    Favorite* fav = [[aFetchedResultsController fetchedObjects] objectAtIndex:0];
    [aFetchedResultsController release];
    
    return fav;
}

+(BOOL)existsWithLine:(Line *)line andStop:(Stop *)stop andOhBTWIncCounter:(BOOL)incCounter {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];

    Favorite* fav = [[Favorite fetchWithLine:line andStop:stop inContext:context] retain];
    if ( fav != nil ) {
        if ( incCounter ) {
            fav.view_count = [NSNumber numberWithInt:([fav.view_count intValue]+1)];
            NSError* error = nil;
            if ( ! [context save:&error] ) {
                NSLog( @"unsable to save" );
            }            
        }
        [fav release];
        return YES;
    }
    return NO;
}

+ (BOOL)existsWithLine:(Line*)line andStop:(Stop*) stop{
    return [Favorite existsWithLine:line andStop:stop andOhBTWIncCounter:NO];
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
        return;
    }
    [NSFetchedResultsController deleteCacheWithName:@"allFavorites"];
}

+ (void)deleteWithLine:(Line*)line andStop:(Stop*) stop {   
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];

    Favorite* fav = [Favorite fetchWithLine:line andStop:stop];
    [context deleteObject:fav];
    
    NSError* error = nil;
    if ( ! [context save:&error] ) {
        NSLog( @"unsable to save" );
        return;
    }  
    [NSFetchedResultsController deleteCacheWithName:@"allFavorites"];
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
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"view_count" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    [NSFetchedResultsController deleteCacheWithName:@"topFavorites"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"topFavorites"];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    NSArray* favs = [aFetchedResultsController fetchedObjects];
    [aFetchedResultsController release];
    return favs;
    
}

+ (NSFetchedResultsController*)findAll {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Favorite entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"line_short_name" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"stop_name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    [NSFetchedResultsController deleteCacheWithName:@"allFavorites"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"allFavorites"];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptor2 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    return [aFetchedResultsController autorelease];
}


-(NSString*)title {
    if ( self.line_id != nil ) {
        return [NSString stringWithFormat:NSLocalizedString( @"Ligne %@ à %@", @""), self.line_short_name, self.stop_name];
    } else {
        return [NSString stringWithFormat:NSLocalizedString( @"Arrêt %@", @"" ), self.stop_name];
    }
}

-(BOOL)couldUpdateReferences {
    Line* line = ( self.line_id != nil ) ? [Line findFirstBySrcId:self.line_id] : nil;
    Stop* stop = [Stop findFirstBySrcId:self.stop_id];
    
    if ( nil != self.line_id && nil == line ) {
        if ( [self.line_id hasPrefix:@"SNT"] ) {
            self.line_id = @"89"; // ugh!
        } else {
            return NO;
        }
    }
    
    if ( nil == stop ) {
        StopAlias* stopAlias = [StopAlias findBySrcId:self.stop_id];
        if ( nil == stopAlias) {
            return NO;
        }
        NSLog( @" old_id = %@, new id = %@", self.stop_id, stopAlias.stop.src_id );
        self.stop_id = stopAlias.stop.src_id;
    }
    return YES;
}

- (void) suicide {
    NSManagedObjectContext* context = [(SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate] userManagedObjectContext];
    [context deleteObject: self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
    NSError* error = nil;
    if ( ! [context save:&error] ) {
        NSLog( @"unsable to save" );
        return;
    }  
    [NSFetchedResultsController deleteCacheWithName:@"allFavorites"];
}

+ (void)updateAll {
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = [delegate  userManagedObjectContext];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Favorite entityInManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"line_short_name" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"stop_name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    [NSFetchedResultsController deleteCacheWithName:@"allFavorites"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"allFavorites"];
    
    [fetchRequest release];
    [sortDescriptor1 release];
    [sortDescriptor2 release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        [aFetchedResultsController release];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return;
    }
    
    NSArray* favs = [aFetchedResultsController fetchedObjects];
    for( Favorite* fav in favs ) {
        if ( fav.line_id != nil ) {
            // 2 numerals as id, pre-september style
            if ( [fav.line_id length] < 4 ) {
                NSString* old_id = fav.line_id;
                if ( [old_id isEqualToString:@"89"] ) {
                    fav.line_id = @"0089";
                    goto skip_line_handling; // no dinosaurs around ?
                }
                Line* new_line = [Line findByOldId:old_id];
                if ( new_line != nil ) {
                    NSLog( @"update line_id : %@ -> %@", fav.line_id, new_line.src_id );
                    fav.line_id = new_line.src_id;
                } else {
                    NSLog( @"unable to find line_id %@", fav.line_id ); 
                    // TODO: suicide
                }
            }
        }
    skip_line_handling:
        if ( ! [[fav.stop_id stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] isEqualToString:@""] ) {
            Stop* new_stop = [Stop findFirstByOldSrcId:fav.stop_id];
            if ( new_stop != nil ) {
                NSLog( @"update stop_id : %@ -> %@", fav.stop_id, new_stop.src_id );
                fav.stop_id = new_stop.src_id;
            } else {
                StopAlias* new_alias = [StopAlias findByOldSrcId:fav.stop_id];
                if ( new_alias != nil ) {
                    fav.stop_id = new_alias.stop.src_id;
                } else {
                    NSLog( @"unable to find stop_id %@", fav.stop_id ); 
                }
            }
        }
    }
    
    [aFetchedResultsController release];    
}

@end
