//
//  APIStopTime.m
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import "APIStopTime.h"


@implementation APIStopTime

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.line, self.stop, self.direction, self.date];
}

@end
