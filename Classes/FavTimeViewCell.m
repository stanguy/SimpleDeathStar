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

NSString* direction2label( NSString* bearing ) {
    NSString* dirString =  [NSString stringWithFormat:@"direction %@", bearing];
    return NSLocalizedString( dirString, @"" );
}

- (void)displayFavorite:(Favorite*)favorite withTimes:(NSArray*)times{
    self.nameLabel.text = [favorite title];
    int time_count = [times count];
    if ( time_count == 0 ){
        self.nameLabel.textColor = [UIColor lightGrayColor];
        return;
    }
    const int kBaseLineY = 20;
    const int kBaseLineX = 20;
    const int kImageWidth = 22;
    const int kLineHeight = 22;
    const int kLabelWidth = 37;
    const int kMarginIn = 5;
    const int kMarginOut = 2;
    const int kGlobalTimeWidth = kImageWidth + kLabelWidth + kMarginIn + kMarginOut;
    for ( int i = 0 ; i < time_count; ++i) {
        StopTime* time = [times objectAtIndex:i];
        int subcell_x = kBaseLineX + i * kGlobalTimeWidth;
        if ( time.trip_bearing != nil ) {
            CGRect  viewRect = CGRectMake( subcell_x, kBaseLineY, kImageWidth, kLineHeight );
            UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"arrow_%@", time.trip_bearing]]];
            imageView.frame = viewRect;
            imageView.contentMode =  UIViewContentModeCenter;
            imageView.accessibilityLabel = direction2label( time.trip_bearing );
            imageView.isAccessibilityElement = YES;
            [self addSubview:imageView];
            [imageView release];
        }
        CGRect  viewRect = CGRectMake( subcell_x + kImageWidth + kMarginIn, kBaseLineY, kLabelWidth, kLineHeight - 2);
        UILabel* timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.frame = viewRect;
        timeLabel.text = [time formatArrival];
        [self addSubview:timeLabel];
        [timeLabel release];
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
