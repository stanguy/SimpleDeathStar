//
//  FavTimeViewCell.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/26/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "FavTimeViewCell.h"
#import "Direction.h"
#import "Favorite.h"
#import "Line.h"
#import "Stop.h"
#import "StopTime.h"

@implementation FavTimeViewCell

@synthesize favorite = favorite_, times = times_, stop = stop_;


-(void) setFramesAt:(int)i{
    const int kBaseLineY = 30;
    const int kBaseLineX = 20;
    const int kImageWidth = 22;
    const int kLineHeight = 22;
    const int kLabelWidth = 37;
    const int kMarginIn = 5;
    const int kMarginOut = 2;
    const int kGlobalTimeWidth = kImageWidth + kLabelWidth + kMarginIn + kMarginOut;

    int subcell_x = kBaseLineX + i * kGlobalTimeWidth;
    CGRect  viewRect = CGRectMake( subcell_x, kBaseLineY, kImageWidth, kLineHeight );
    imageViews_[i].frame = viewRect;
    viewRect = CGRectMake( subcell_x + kImageWidth + kMarginIn, kBaseLineY, kLabelWidth, kLineHeight - 2);
    timeLabels_[i].frame = viewRect;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        nameLabel_ = [[UILabel alloc] init];
        nameLabel_.backgroundColor = [UIColor clearColor];
        nameLabel_.frame = CGRectMake( 30, 5, 250, 20 );
        nameLabel_.font = [UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:nameLabel_];

        distanceLabel_ = [[UILabel alloc] init];
        distanceLabel_.backgroundColor = [UIColor clearColor];
        distanceLabel_.frame = CGRectMake( self.contentView.frame.size.width - 60, 5, 50, 20 );
        distanceLabel_.font = [UIFont boldSystemFontOfSize:12.0];
        distanceLabel_.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:distanceLabel_];
        
        timeLabels_ = malloc( sizeof(UILabel*) * 4 );
        imageViews_ = malloc( sizeof(UIImageView*) * 4 );
        
        for ( int i = 0 ; i < 4; ++i) {
            imageViews_[i] = [[UIImageView alloc] init];
            timeLabels_[i] = [[UILabel alloc] init];

            [self setFramesAt:i];

            imageViews_[i].contentMode =  UIViewContentModeCenter;
            timeLabels_[i].font = [UIFont systemFontOfSize:12];
            timeLabels_[i].textAlignment = UITextAlignmentRight;
            timeLabels_[i].backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:imageViews_[i]];
            [self.contentView addSubview:timeLabels_[i]];

            [imageViews_[i] release];
            [timeLabels_[i] release];
        }
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if ( ( self.contentView.frame.size.width - 60 ) != distanceLabel_.frame.origin.x ) {
        distanceLabel_.frame = CGRectMake( self.contentView.frame.size.width - 60, 5, 50, 20 );
    }
}


- (void)prepareForReuse {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    nameLabel_.textColor = [UIColor blackColor];
    distanceLabel_.text = @"";
    for ( int i = 0; i < 4; ++i) {
        imageViews_[i].hidden = YES;
        timeLabels_[i].hidden = YES;
        timeLabels_[i].textColor = [UIColor blackColor];
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

-(void)setStop:(Stop *)stop {
    stop_ = [stop retain];
    nameLabel_.text = stop.name;
    distanceLabel_.text = [NSString stringWithFormat:@"%d m", stop.distance];
}

-(void) formatTime:(StopTime*)st atIndex:(int)i{
    timeLabels_[i].text = [st formatTime];
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
        NSString *directionName = stime.direction.headsign;
        if ( self.favorite.line_id != nil ) {
            directionName = [NSString stringWithFormat:NSLocalizedString( @"%@ vers %@", @"" ), self.favorite.line_short_name, directionName];
        } else {
            directionName = [NSString stringWithFormat:NSLocalizedString( @"%@ vers %@", @"" ), stime.line.short_name, directionName];
        }
        imageViews_[i].accessibilityLabel = directionName;
        [self formatTime:stime atIndex:i];
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
