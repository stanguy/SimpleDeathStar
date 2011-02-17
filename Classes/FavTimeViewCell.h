//
//  FavTimeViewCell.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/26/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Favorite;

@interface FavTimeViewCell : UITableViewCell {

 @private
    Favorite* favorite_;
    NSArray* times_;
    
    UILabel* nameLabel_;
    UILabel** timeLabels_;
    UIImageView** imageViews_;
    
}
@property (nonatomic, retain) Favorite* favorite;
@property (nonatomic, retain) NSArray* times;

@end
