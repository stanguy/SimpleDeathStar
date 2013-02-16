//
//  APIStopTime.m
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import "APIStopTime.h"
#import "Line.h"
#import "Stop.h"


@implementation APIStopTime

@synthesize stop,line,accurate,departure,direction,remoteReferenceTime;

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.line.short_name, self.stop.name, self.direction, self.departure];
}

-(BOOL)canDistinguistArrivalAndDeparture {
    return NO;
}

-(NSString*)departure:(NSDate *)relative_date{
    NSString* result;
    if ( nil == relative_date ) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        result = [formatter stringFromDate:self.departure];
        [formatter release];
    } else {
        NSTimeInterval diff = [self.departure timeIntervalSinceDate:relative_date];
        result = [NSString stringWithFormat:@"%d", (int)(diff / 60)];
    }
    return result;
}

@end
