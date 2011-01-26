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

    IBOutlet UILabel *nameLabel;
}
@property (nonatomic, retain) UILabel *nameLabel;


- (void)displayFavorite:(Favorite*)favorite;

+ (FavTimeViewCell *)cellFromNibNamed:(NSString *)nibName;

@end
