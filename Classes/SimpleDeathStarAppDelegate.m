//
//  SimpleDeathStarAppDelegate.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "SimpleDeathStarAppDelegate.h"
#import "HomeScreenViewController.h"
#import "MultiColumnsHomeScreenViewController.h"
#import "Favorite.h"

#import <iAd/ADBannerView.h>
#import "ADViewComposer.h"
#import "Screenshoter.h"

@implementation SimpleDeathStarAppDelegate

@synthesize window;
@synthesize useArrival;
@synthesize useRelativeTime;
@synthesize navigationController;
@synthesize adView = adView_;


#pragma mark -
#pragma mark Application lifecycle

- (void)handleTimer:(NSTimer*)t {
    HomeScreenViewController* home = [navigationController.viewControllers objectAtIndex:0];
    [home reloadByTimer];
}

- (void)locationActive:(BOOL)shouldActivate {
    if ( shouldActivate ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationRetry" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationStop" object:nil];
    }
}

- (void)createTimer {
    timerFavorites = [NSTimer scheduledTimerWithTimeInterval: 90
                                                      target: self
                                                    selector: @selector(handleTimer:)
                                                    userInfo: nil
                                                     repeats: YES];
}    

+ (id)adView {
    SimpleDeathStarAppDelegate* appDelegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    return appDelegate.adView;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [window setFrame:[[UIScreen mainScreen] bounds]];
    NSLog( @"%f", [[UIScreen mainScreen] bounds].size.height );
    
    // Override point for customization after application launch.
    NSDictionary* appDefaults = 
    [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:YES], @"enable_ads",
         @"arrival",                    @"reftime", 
         [NSNumber numberWithBool:FALSE], @"relative_time", nil ];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults] ;
    [defaults registerDefaults:appDefaults];
    [defaults setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"version"];
#ifndef VERSION_STLO
    [Favorite updateAll];
#endif
    
    NSString* reftime = [defaults stringForKey:@"reftime"];
    useArrival = YES;
    if ( [reftime isEqualToString:@"departure"]) {
        useArrival = NO;
    }
    
    useRelativeTime = [defaults boolForKey:@"relative_time"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    UIViewController* home;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        MultiColumnsHomeScreenViewController* tmp_home = [[[MultiColumnsHomeScreenViewController alloc] init] autorelease];
        NSNumber* page = [defaults objectForKey:@"startupPage"];
        if ( nil != page ) {
            tmp_home.pageControl.currentPage = [page intValue];
        }
        [tmp_home switchPage:true];
        home = tmp_home;
    } else {
        home = [[[HomeScreenViewController alloc] init] autorelease];
    }
    if ( [defaults boolForKey:@"enable_ads"] ) {
#ifndef VERSION_STLO
        NSLog( @"ads enabled" );
        [ADViewComposer EnableAds:YES];
        adView_ = [[ADViewComposer BuildAdView:home.view] retain];
#endif
    } else {
        [ADViewComposer EnableAds:NO];
    }
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:home];
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
#ifdef CAN_SCREENSHOT
    self.screenshoter = [[[Screenshoter alloc] init] autorelease];
    navigationController.delegate = self.screenshoter;
#endif
    return YES;
}

- (void)preferencesChanged:(NSNotification*) notification {
    NSLog( @"notice preferences change" );
    NSUserDefaults* defaults = (NSUserDefaults*) [notification object];
    if ( [defaults boolForKey:@"enable_ads"] ) {
#ifndef VERSION_STLO
        if ( adView_ == nil ) {
            [ADViewComposer EnableAds:YES];
            HomeScreenViewController* homeController = [navigationController.viewControllers objectAtIndex:0];
            adView_ = [[ADViewComposer BuildAdView:homeController.view] retain];
        }
#endif
    } else {
        if ( adView_ != nil ) {
            [ADViewComposer EnableAds:NO];
            ADViewComposer* currentComposer = [adView_ delegate];
            [currentComposer toDisappear];
            [adView_ release];
            adView_ = nil;
        }
    }
    NSString* reftime = [[NSUserDefaults standardUserDefaults] stringForKey:@"reftime"];
    if ( [reftime isEqualToString:@"arrival"]) {
        useArrival = YES;
    } else {
        useArrival = NO;
    }
    useRelativeTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"relative_time"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"preferencesChanged" object:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [timerFavorites invalidate];
    [self locationActive:NO];
    
    UIViewController* home = [navigationController.viewControllers objectAtIndex:0];
    if ( [home isKindOfClass:[MultiColumnsHomeScreenViewController class]]) {
        MultiColumnsHomeScreenViewController* home_col = (MultiColumnsHomeScreenViewController*)home;
        NSInteger currentPage = home_col.pageControl.currentPage;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults] ;
        [defaults setObject:[NSNumber numberWithInteger:currentPage] forKey:@"startupPage"];
    }
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
    @synchronized(self) {
        if (transitManagedObjectContext_ != nil ) {
            return transitManagedObjectContext_;
        }
        NSPersistentStoreCoordinator *coordinator = [self transitPersistentStoreCoordinator];
        if (coordinator != nil) {
            transitManagedObjectContext_ = [[NSManagedObjectContext alloc] init];
            [transitManagedObjectContext_ setUndoManager:nil];
            [transitManagedObjectContext_ setPersistentStoreCoordinator:coordinator];
        }
        return transitManagedObjectContext_;
    }
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)transitManagedObjectModel {
    @synchronized(self) {
        if (transitManagedObjectModel_ != nil) {
            return transitManagedObjectModel_;
        }
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Transit" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        transitManagedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
        return transitManagedObjectModel_;
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)userManagedObjectContext {
    @synchronized(self) {
        if (userManagedObjectContext_ != nil) {
            return userManagedObjectContext_;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self userPersistentStoreCoordinator];
        if (coordinator != nil) {
            userManagedObjectContext_ = [[NSManagedObjectContext alloc] init];
            [userManagedObjectContext_ setUndoManager:nil];
            [userManagedObjectContext_ setPersistentStoreCoordinator:coordinator];
        }
        return userManagedObjectContext_;
    }
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)userManagedObjectModel {
    @synchronized(self) {
        if (userManagedObjectModel_ != nil) {
            return userManagedObjectModel_;
        }
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        userManagedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
        return userManagedObjectModel_;
    }
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)transitPersistentStoreCoordinator {
    @synchronized(self) {
        if (transitPersistentStoreCoordinator_ != nil) {
            return transitPersistentStoreCoordinator_;
        }
#ifndef VERSION_STLO
        NSString* dbName = @"Transit";
#else
        NSString* dbName = @"TransitStLo";
#endif
        NSURL *storeURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"]];
        NSDictionary 
          *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:1]
                                                 forKey:NSReadOnlyPersistentStoreOption];
        
        
        NSError *error = nil;
        transitPersistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self transitManagedObjectModel]];
        if (![transitPersistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
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
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)userPersistentStoreCoordinator {
    @synchronized(self) {
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

