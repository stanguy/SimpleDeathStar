//
//  NSObject+ToQuery.h
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ToQuery)

-(NSString*) to_query:(NSString*)namespace;
-(NSString*) to_query;


@end
