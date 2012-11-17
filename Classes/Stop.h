//
//  Stop.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "_Stop.h"

@class NSManagegObjectContext;

@interface Stop : _Stop {
    int distance_;
}

@property int distance;

+ (NSFetchedResultsController*) findAll;
+ (NSFetchedResultsController*) findByName:(NSString*) text;
+ (Stop*) findFirstBySrcId:(NSString*)src_id;
+ (Stop*) findFirstBySlug:(NSString*)slug;
+ (NSArray*) findAroundLocation:(CLLocation*)location withinContext:(NSManagedObjectContext*)context;
+ (NSArray*) findFromPosition:(CLLocationCoordinate2D)center
            withLatitudeDelta:(CLLocationDegrees)latitudeDelta
            andLongitudeDelta:(CLLocationDegrees)longitudeDelta;
+ (Stop*)findFirstByOldSrcId:(NSString*)old_src_id;

- (int) allCounts;

@end
