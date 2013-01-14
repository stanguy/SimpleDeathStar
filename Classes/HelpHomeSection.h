//
//  HelpHomeSection.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "SimpleMenuHomeSection.h"

typedef enum  {
    kHelpFull,
    kHelpLocal,
    kHelpRemote
} HelpType;

@interface HelpHomeSection : SimpleMenuHomeSection

-(id)initWithType:(HelpType)type;

@property (nonatomic, retain) NSString* title;

@end
