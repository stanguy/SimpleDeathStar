//
//  FavTimeViewCell.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/26/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "FavTimeViewCell.h"
#import "StopTime.h"

@implementation FavTimeViewCell

@synthesize nameLabel;


+ (FavTimeViewCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    FavTimeViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[FavTimeViewCell class]]) {
            customCell = (FavTimeViewCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)displayFavorite:(Favorite*)favorite withTimes:(NSArray*)times{
    self.nameLabel.text = [favorite title];
    int time_count = [times count];
    if ( time_count == 0 ){
        self.nameLabel.textColor = [UIColor lightGrayColor];
    }
    for ( int i = 0 ; i < 4; ++i) {
        UILabel* timeLabel = (UILabel*) [self viewWithTag:(10+i*2+1)];
        UIImageView* imageView = (UIImageView*) [self viewWithTag:(10+i*2)];
        if ( i < time_count ) {
            StopTime* time = [times objectAtIndex:i];
            timeLabel.text = [time formatArrival];
            if ( time.trip_bearing != nil ) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"arrow_%@", time.trip_bearing]];
            } else {
                imageView.hidden = YES;
            }
        } else {
            timeLabel.hidden = YES;
            imageView.hidden = YES;
        }
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
