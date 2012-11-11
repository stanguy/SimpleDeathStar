//
//  SimpleMenuHomeSection.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractHomeSection.h"

@interface SimpleMenuHomeSection : AbstractHomeSection

- (NSInteger)numberOfElements;

@property (retain) NSArray* menu;
@property (retain) NSString* title;

@end
