//
//  SimpleDeathStarAppDelegate.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SimpleDeathStarAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    
@private
    NSManagedObjectContext *transitManagedObjectContext_;
    NSManagedObjectModel *transitManagedObjectModel_;

    NSManagedObjectContext *userManagedObjectContext_;
    NSManagedObjectModel *userManagedObjectModel_;

    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *transitManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *transitManagedObjectModel;

@property (nonatomic, retain, readonly) NSManagedObjectContext *userManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *userManagedObjectModel;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end

