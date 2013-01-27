//
//  TimePresenterSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 1/25/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import "StopTimeFormatter.h"
#import "TimePresenterSection.h"
#import "SimpleDeathStarAppDelegate.h"
#import "StopTimeFormatter.h"

@implementation TimePresenterSection

@synthesize time_formatter;

-(id)init {
    self = [super init];
    if ( self ) {
        self.time_formatter = [[StopTimeFormatter alloc] init];
        SimpleDeathStarAppDelegate* app = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.time_formatter.relative = app.useRelativeTime;
        self.time_formatter.time_type = app.useArrival ? STOPTIME_ARRIVAL : STOPTIME_DEPARTURE;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPreferences:) name:@"preferencesChanged" object:nil];

    }
    return self;
}

-(void)resetPreferences:(NSNotification*)notification {
    SimpleDeathStarAppDelegate* app = notification.object;
    NSLog( @"reset preferences (TimePresenter)" );
    self.time_formatter.relative = app.useRelativeTime;
    self.time_formatter.time_type = app.useArrival ? STOPTIME_ARRIVAL : STOPTIME_DEPARTURE;
}

@end
