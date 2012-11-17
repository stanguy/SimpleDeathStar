//
//  AbstractHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "AbstractHomeSection.h"

@implementation AbstractHomeSection

@synthesize title;

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)reloadByTimer{}


-(CGFloat)rowHeight {
    return 44.0f;
}


@end
