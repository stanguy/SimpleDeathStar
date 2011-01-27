//
//  StopViewCell.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/27/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StopViewCell : UITableViewCell {

    IBOutlet UIImageView* accessible;
    IBOutlet UIImageView* pos;
    IBOutlet UIImageView* bike;
    IBOutlet UIImageView* metro;
    IBOutlet UILabel* name;
    IBOutlet UILabel* lines;
}
@property (nonatomic, retain) UIImageView *accessible;
@property (nonatomic, retain) UIImageView *pos;
@property (nonatomic, retain) UIImageView *bike;
@property (nonatomic, retain) UIImageView *metro;
@property (nonatomic, retain) UILabel* name;
@property (nonatomic, retain) UILabel* lines;

+ (StopViewCell *)cellFromNibNamed:(NSString *)nibName;

@end
