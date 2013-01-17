//
//  Line.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "_Line.h"

enum {
    LINE_USAGE_ALL = 1,
    LINE_USAGE_URBAN,
    LINE_USAGE_SUBURBAN,
    LINE_USAGE_EXPRESS,
    LINE_USAGE_SPECIAL
};

@interface Line : _Line {

}

+ (NSFetchedResultsController*) findAll:(int) type;
+ (Line*) findFirstBySrcId:(NSString*)src_id;
+ (Line*) findFirstBySrcId:(NSString*)src_id inContext:(NSManagedObjectContext*)context;
+ (Line*) findByOldId:(NSString*)old_id;

@end
