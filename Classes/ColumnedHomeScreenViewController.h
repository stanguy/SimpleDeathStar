//
//  ColumnedHomeScreenViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AbstractHomeSection.h"


@interface ColumnedHomeScreenViewController : UITableViewController <HomePageDelegate>

@property (retain) AbstractHomeSection* section;

@end
