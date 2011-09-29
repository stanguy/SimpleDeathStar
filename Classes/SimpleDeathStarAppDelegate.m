//
//  SimpleDeathStarAppDelegate.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "SimpleDeathStarAppDelegate.h"
#import "HomeScreenViewController.h"
#import "Favorite.h"


@implementation SimpleDeathStarAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)handleTimer:(NSTimer*)t {
    HomeScreenViewController* home = [navigationController.viewControllers objectAtIndex:0];
    [home performSelectorInBackground:@selector(reloadFavorites) withObject:nil];
}

- (void)locationActive:(BOOL)shouldActivate {
#ifndef VERSION_STLO
    HomeScreenViewController* home = [navigationController.viewControllers objectAtIndex:0];
    if ( shouldActivate ) {
        [home locationRetry];
    } else {
        [home locationStop];
    }
#endif
}

- (void)createTimer {
    timerFavorites = [NSTimer scheduledTimerWithTimeInterval: 90
                                                      target: self
                                                    selector: @selector(handleTimer:)
                                                    userInfo: nil
                                                     repeats: YES];
}    

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    NSLog( @"didFinishLaunching" );
    [Favorite updateAll];
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [timerFavorites invalidate];
    [self locationActive:NO];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self handleTimer:nil];
    [self createTimer];
    [self locationActive:YES];
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


- (void)saveContext {
    
    NSError *error = nil;
    if (transitManagedObjectContext_ != nil) {
        if ([transitManagedObjectContext_ hasChanges] && ![transitManagedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)transitManagedObjectContext {
    
    if (transitManagedObjectContext_ != nil) {
        return transitManagedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self transitPersistentStoreCoordinator];
    if (coordinator != nil) {
        transitManagedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [transitManagedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return transitManagedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)transitManagedObjectModel {
    
    if (transitManagedObjectModel_ != nil) {
        return transitManagedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Transit" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    transitManagedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return transitManagedObjectModel_;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)userManagedObjectContext {
    
    if (userManagedObjectContext_ != nil) {
        return userManagedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self userPersistentStoreCoordinator];
    if (coordinator != nil) {
        userManagedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [userManagedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return userManagedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)userManagedObjectModel {
    
    if (userManagedObjectModel_ != nil) {
        return userManagedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    userManagedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return userManagedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)transitPersistentStoreCoordinator {
    
    if (transitPersistentStoreCoordinator_ != nil) {
        return transitPersistentStoreCoordinator_;
    }
#ifndef VERSION_STLO
    NSString* dbName = @"Transit";
#else
    NSString* dbName = @"TransitStLo";
#endif
    NSURL *storeURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"]];
    
    NSError *error = nil;
    transitPersistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self transitManagedObjectModel]];
    if (![transitPersistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return transitPersistentStoreCoordinator_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)userPersistentStoreCoordinator {
    
    if (userPersistentStoreCoordinator_ != nil) {
        return userPersistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"User.sqlite"]];
    
    NSError *error = nil;
    userPersistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self userManagedObjectModel]];
    if (![userPersistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return userPersistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [timerFavorites invalidate];
    [transitManagedObjectContext_ release];
    [transitManagedObjectModel_ release];
    [transitPersistentStoreCoordinator_ release];
    
    [navigationController release];
    [window release];
    [super dealloc];
}


@end

