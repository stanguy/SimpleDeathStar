//
//  StopViewCell.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/27/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "StopViewCell.h"


@implementation StopViewCell

@synthesize accessible, pos, bike, metro,name, lines;


+ (StopViewCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    StopViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[StopViewCell class]]) {
            customCell = (StopViewCell *)nibItem;
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
