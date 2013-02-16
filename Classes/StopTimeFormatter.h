//
//  StopTimeFormatter.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 1/21/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimePoint.h"

enum  {
    STOPTIME_DEPARTURE = 1,
    STOPTIME_ARRIVAL
} ;


@interface StopTimeFormatter : NSObject


-(NSString*)format:(id<TimePoint>)timepoint;
-(void)resetDefaults;

@property (atomic) BOOL relative;
@property (atomic) NSInteger time_type;
@property (atomic,retain) NSDate* ref_date;

@end
