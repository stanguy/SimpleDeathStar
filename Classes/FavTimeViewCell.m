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

@synthesize favorite = favorite_, times = times_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        nameLabel_ = [[UILabel alloc] init];
        nameLabel_.frame = CGRectMake( 30, 2, 250, 20 );
        nameLabel_.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:nameLabel_];
        
        timeLabels_ = malloc( sizeof(UILabel*) * 4 );
        imageViews_ = malloc( sizeof(UIImageView) * 4 );
        
        const int kBaseLineY = 20;
        const int kBaseLineX = 20;
        const int kImageWidth = 22;
        const int kLineHeight = 22;
        const int kLabelWidth = 37;
        const int kMarginIn = 5;
        const int kMarginOut = 2;
        const int kGlobalTimeWidth = kImageWidth + kLabelWidth + kMarginIn + kMarginOut;
        for ( int i = 0 ; i < 4; ++i) {
            int subcell_x = kBaseLineX + i * kGlobalTimeWidth;
            CGRect  viewRect = CGRectMake( subcell_x, kBaseLineY, kImageWidth, kLineHeight );
            imageViews_[i] = [[UIImageView alloc] init];
            imageViews_[i].frame = viewRect;
            imageViews_[i].contentMode =  UIViewContentModeCenter;
            imageViews_[i].isAccessibilityElement = YES;
            [self addSubview:imageViews_[i]];
            [imageViews_[i] release];
            viewRect = CGRectMake( subcell_x + kImageWidth + kMarginIn, kBaseLineY, kLabelWidth, kLineHeight - 2);
            timeLabels_[i] = [[UILabel alloc] init];
            timeLabels_[i].font = [UIFont systemFontOfSize:12];
            timeLabels_[i].frame = viewRect;
            [self addSubview:timeLabels_[i]];
            [timeLabels_[i] release];
        }
    }
    return self;
}

- (void)prepareForReuse {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    nameLabel_.textColor = [UIColor blackColor];
    for ( int i = 0; i < 4; ++i) {
        imageViews_[i].hidden = YES;
        timeLabels_[i].hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

NSString* direction2label( NSString* bearing ) {
    NSString* dirString =  [NSString stringWithFormat:@"direction %@", bearing];
    return NSLocalizedString( dirString, @"" );
}

-(void)setFavorite:(Favorite *)fav {
    favorite_ = [fav retain];
    nameLabel_.text = [favorite_ title];
}

-(void)setTimes:(NSArray *)times {
    times_ = [times retain];
    if (nil == times || (NSArray*)[NSNull null] == times) {
        self.accessoryType = UITableViewCellAccessoryNone;
        nameLabel_.textColor = [UIColor redColor];
        return;
    }
    int time_count = [times_ count];
    if ( time_count == 0 ){
        nameLabel_.textColor = [UIColor lightGrayColor];
        return;
    }
    for ( int i = 0; i < time_count; ++i ) {
        StopTime* stime = [times objectAtIndex:i];
        NSString* bearing = stime.trip_bearing;
        if( nil == bearing ) {
            bearing = @"circle_right";
        }
        imageViews_[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"arrow_%@", bearing]];
        timeLabels_[i].text = [stime formatArrival];
        imageViews_[i].hidden = NO;
        timeLabels_[i].hidden = NO;
    }
}


- (void)dealloc {
    free( timeLabels_ );
    free( imageViews_ );
    [super dealloc];
}


@end
