//
//  TimePresenterSection.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 1/25/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import "AbstractHomeSection.h"

@class StopTimeFormatter;


@interface TimePresenterSection : AbstractHomeSection

@property (nonatomic,retain) StopTimeFormatter* time_formatter;

@end
