//
//  KeolisRennesAPI.h
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Line;
@class Stop;
@class APIStopTime;

@interface KeolisRennesAPI : NSObject

- (NSArray*) findNextDepartureAtStop:(Stop*)stop error:(NSError**)error;

@property (nonatomic,retain) NSString* key;

@end
