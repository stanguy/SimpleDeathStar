//
//  FavTimeViewCell.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/26/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Favorite;
@class StopTime;
@class Stop;
@class StopTimeFormatter;

@interface FavTimeViewCell : UITableViewCell {

 @private
    Favorite* favorite_;
    Stop* stop_;
    NSArray* times_;
 @protected
    UILabel* nameLabel_;
    UILabel* distanceLabel_;
    UILabel** timeLabels_;
    UIImageView** imageViews_;
    
}
@property (nonatomic, retain) Favorite* favorite;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) NSArray* times;
@property (nonatomic, retain) StopTimeFormatter* time_formatter;

// semi-protected
-(void) setFramesAt:(int)i;
-(void) formatTime:(StopTime*)st atIndex:(int)i;

@end
