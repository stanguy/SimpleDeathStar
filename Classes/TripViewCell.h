//
//  TripViewCell.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/28/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TripViewCell : UITableViewCell {
    IBOutlet UIImageView* accessible;
    IBOutlet UIImageView* pos;
    IBOutlet UIImageView* bike;
    IBOutlet UIImageView* metro;
    IBOutlet UILabel* arrivalTime;
    IBOutlet UILabel* stopName;
    
}
@property (nonatomic, retain) UIImageView *accessible;
@property (nonatomic, retain) UIImageView *pos;
@property (nonatomic, retain) UIImageView *bike;
@property (nonatomic, retain) UIImageView *metro;
@property (nonatomic, retain) UILabel* arrivalTime;
@property (nonatomic, retain) UILabel* stopName;

+ (TripViewCell *)cellFromNibNamed:(NSString *)nibName;

@end
