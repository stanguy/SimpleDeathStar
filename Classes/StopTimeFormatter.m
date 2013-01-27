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

-(id)init {
    self = [super init];
    if ( self ) {
        SimpleDeathStarAppDelegate* app = [[UIApplication sharedApplication] delegate];
        self.time_type = app.useArrival ? STOPTIME_ARRIVAL : STOPTIME_DEPARTURE;
        self.relative = FALSE;
    }
    return self;
}

-(NSString*)format:(id<TimePoint>)timepoint {
    if ( [timepoint canDistinguistArrivalAndDeparture] ) {
        NSNumber* dbvalue;
        switch ( self.time_type ) {
            case STOPTIME_ARRIVAL:
                dbvalue = timepoint.arrival;
                break;
            case STOPTIME_DEPARTURE:
                dbvalue = timepoint.departure;
                break;
        }
        int arrival = [dbvalue intValue] / 60;
        if ( self.relative ) {
            NSDate* date = [NSDate date];
            NSDateComponents *dateComponents = dateToComponents( date );
            int reft = [dateComponents hour] * 60 + [dateComponents minute];
            if ( arrival > 24 * 60 ) {
                if ( reft < 12 * 60 ) {
                    reft = reft + 24*60;
                }
            }
            return [NSString stringWithFormat:@"%d", arrival - reft];
        } else {
            int mins = arrival % 60;
            int hours = ( arrival / 60 ) % 24;
            return [NSString stringWithFormat:@"%02d:%02d", hours, mins];
        }
    } else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        return  [formatter stringFromDate:timepoint.departure];
    }
}

@end
