//
//  StopTimeFormatter.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 1/21/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import "StopTimeFormatter.h"
#import "SimpleDeathStarAppDelegate.h"

NSDateComponents* dateToComponents( NSDate* date );

@interface StopTimeFormatter () {
}

@end

@implementation StopTimeFormatter

@synthesize relative,time_type,ref_date;

-(id)init {
    self = [super init];
    if ( self ) {
        SimpleDeathStarAppDelegate* app = [[UIApplication sharedApplication] delegate];
        self.time_type = app.useArrival ? STOPTIME_ARRIVAL : STOPTIME_DEPARTURE;
        self.relative = FALSE;
        self.ref_date = nil;
    }
    return self;
}

-(NSString*)format:(id<TimePoint>)timepoint {
    SEL format_selector;
    if ( self.time_type == STOPTIME_ARRIVAL && [timepoint canDistinguistArrivalAndDeparture]) {
        format_selector = @selector(arrival:);
    } else {
        format_selector = @selector(departure:);
    }
    NSDate* date = nil;
    if ( self.relative ) {
        if ( nil == self.ref_date ) {
            date = [NSDate date];
        } else {
            date = self.ref_date;
        }
    }
    return [timepoint performSelector:format_selector withObject:date];
}

@end
