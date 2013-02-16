//
//  SimpleDeathStarAppDelegate.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#ifdef CAN_SCREENSHOT
#import "Screenshoter.h"
#endif

@interface SimpleDeathStarAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;

@private
    NSManagedObjectContext *transitManagedObjectContext_;
    NSManagedObjectModel *transitManagedObjectModel_;

    NSManagedObjectContext *userManagedObjectContext_;
    NSManagedObjectModel *userManagedObjectModel_;

    NSPersistentStoreCoordinator *transitPersistentStoreCoordinator_;
    NSPersistentStoreCoordinator *userPersistentStoreCoordinator_;
    
    NSTimer* timerFavorites;
    id adView_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *transitManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *transitManagedObjectModel;

@property (nonatomic, retain, readonly) NSManagedObjectContext *userManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *userManagedObjectModel;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *transitPersistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *userPersistentStoreCoordinator;
@property (nonatomic, retain) id adView;
@property BOOL useArrival;
@property BOOL useRelativeTime;
#ifdef CAN_SCREENSHOT
@property (nonatomic, retain) Screenshoter* screenshoter;
#endif

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

+ (id)adView;

@end

#ifdef CAN_SCREENSHOT
#define TAKE_SCREENSHOT(name) if(true) { SimpleDeathStarAppDelegate* _sc_delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate]; [_sc_delegate.screenshoter takeDelayedScreenshot:name]; }
#else
#define TAKE_SCREENSHOT(name)
#endif

