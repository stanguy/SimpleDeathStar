//
//  APIStopTime.h
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stop;
@class Line;

@interface APIStopTime : NSObject


@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) Line* line;
@property (nonatomic, retain) NSString* direction;
@property (atomic) BOOL accurate;
@property (nonatomic, retain) NSDate* date;

@end
