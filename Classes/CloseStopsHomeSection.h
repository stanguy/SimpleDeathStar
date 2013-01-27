//
//  CloseStopsHomeSection.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TimePresenterSection.h"

@interface CloseStopsHomeSection : TimePresenterSection <CLLocationManagerDelegate> {
    
    int closeStopsCount;
    int positioningError;
    
    time_t lastUpdate;
    int currentDelay;
}

@property (retain) CLLocationManager *locationManager;
@property (retain) NSArray* closeStops;
@property (retain) NSArray* proximityTimes;

-(NSString*)title;

@end
