//
//  TimePoint.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 1/22/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimePoint <NSObject>

- (BOOL)canDistinguistArrivalAndDeparture;
- (NSString*)departure:(NSDate*)relative_date;

@optional
- (NSString*)arrival:(NSDate*)relative_date;

@end
