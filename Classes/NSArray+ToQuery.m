//
//  NSArray+ToQuery.m
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import "NSArray+ToQuery.h"
#import "NSObject+ToQuery.h"

@implementation NSArray (ToQuery)

-(NSString*) to_query:(NSString*)namespace{
    NSString* prefix = [NSString stringWithFormat:@"%@[]", namespace];
    NSMutableArray* values = [NSMutableArray arrayWithCapacity:[self count]];
    for ( NSObject* value in self ) {
        [values addObject:[value to_query:prefix]];
    }
    return [values componentsJoinedByString:@"&"];
}

@end
