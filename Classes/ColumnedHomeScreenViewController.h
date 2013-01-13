//
//  ColumnedHomeScreenViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AbstractHomeSection.h"
#import "ISColumnsController.h"
#import "TableWithAdViewController.h"


@interface ColumnedHomeScreenViewController : TableWithAdViewController <HomePageDelegate,ISColumnsControllerChild>

@property (retain) AbstractHomeSection* section;


- (id)initWithStyle:(UITableViewStyle)style;

@end
