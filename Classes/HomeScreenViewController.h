//
//  HomeScreenViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenViewController : UITableViewController <CLLocationManagerDelegate> {
@private
    NSMutableArray* menus_;
    NSArray* topFavorites_;
    NSArray* favoritesTimes_;
    int cachedFavoritesCount;
    CLLocationManager *locationManager_;
    int closeStopsCount;
    NSArray* closeStops;
    int positioningError;
}

@property (nonatomic, retain) CLLocationManager *locationManager;  

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
- (void) locationRetry;
- (void) locationStop;
@end
