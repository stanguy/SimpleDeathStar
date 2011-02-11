//
//  Stop.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "_Stop.h"


@interface Stop : _Stop {
    int distance_;
}

@property int distance;

+ (NSFetchedResultsController*) findAll;
+ (NSFetchedResultsController*) findByName:(NSString*) text;
+ (Stop*) findFirstBySrcId:(NSString*)src_id;
+ (NSArray*) findAroundLocation:(CLLocation*)location;

- (int) allCounts;

@end
