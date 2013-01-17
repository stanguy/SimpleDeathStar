//
//  NSDictionary+ToQuery.m
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import "NSDictionary+ToQuery.h"

@implementation NSDictionary (ToQuery)

-(NSString*) to_query:(NSString*)namespace
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSString* key in [self keyEnumerator]) {
        id value = [self objectForKey:key];
        NSString* sub_namespace;
        if ( nil != namespace ) {
            sub_namespace = [NSString stringWithFormat:@"%@[%@]", namespace, key];
        } else {
            sub_namespace = key;
        }
        [array addObject:[value to_query:sub_namespace]];
    }
    NSString* result = [array componentsJoinedByString:@"&"];
    // release array;
    return result;
}


@end
