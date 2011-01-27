//
//  TripViewCell.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/28/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "TripViewCell.h"


@implementation TripViewCell

@synthesize accessible, pos, bike, metro,stopName, arrivalTime;


+ (TripViewCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    TripViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[TripViewCell class]]) {
            customCell = (TripViewCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
