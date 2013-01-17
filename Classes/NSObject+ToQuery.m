//
//  NSObject+ToQuery.m
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import "NSObject+ToQuery.h"

@implementation NSObject (ToQuery)

-(NSString*) to_query:(NSString*)namespace
{
    return [NSString stringWithFormat:@"%@=%@", namespace, self];
}


-(NSString*) to_query{
    if ( [self respondsToSelector:@selector(to_query:)] ) {
        return [self performSelector:@selector(to_query:) withObject:nil];
    } else {
        return @"";
    }
}


@end
