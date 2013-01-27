//
//  TimePoint.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 1/22/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimePoint <NSObject>

- (NSString*) formatTime:(int)time_e asRelative:(BOOL)isRelative;
- (BOOL)canDistinguistArrivalAndDeparture;
- (NSNumber*)departure;

@optional
- (NSNumber*)arrival;

@end
