//
//  FavTimeRelativeViewCell.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/28/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "FavTimeRelativeViewCell.h"

#import "StopTime.h"

@implementation FavTimeRelativeViewCell

-(void) setFramesAt:(int)i{
    const int kBaseLineY = 20;
    const int kBaseLineX = 20;
    const int kImageWidth = 22;
    const int kLineHeight = 22;
    const int kLabelWidth = 38;
    const int kMarginIn = 3;
    const int kMarginOut = 4;
    const int kGlobalTimeWidth = kImageWidth + kLabelWidth + kMarginIn + kMarginOut;
    
    int subcell_x = kBaseLineX + i * kGlobalTimeWidth;
    CGRect  viewRect = CGRectMake( subcell_x, kBaseLineY, kImageWidth, kLineHeight );
    imageViews_[i].frame = viewRect;
    viewRect = CGRectMake( subcell_x + kImageWidth + kMarginIn, kBaseLineY, kLabelWidth, kLineHeight - 2);
    timeLabels_[i].frame = viewRect;
    
}

-(void) formatTime:(StopTime*)st atIndex:(int)i{
    NSString* str = [st formatTime:STOPTIME_PREFERENCE asRelative:YES];
    if ( [str length] < 2 ) {
        timeLabels_[i].textColor = [UIColor redColor];
    }
    timeLabels_[i].text = [str stringByAppendingString:@" min"];
}

@end
