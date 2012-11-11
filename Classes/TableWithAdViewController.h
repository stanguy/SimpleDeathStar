//
//  TableWithAdViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/18/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADViewComposer.h"

@interface TableWithAdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
  @private
    ADViewComposer* viewComposer;
}

@property (nonatomic,retain) UITableView* tableView;

- (UITableViewStyle)defaultStyle ;

@end
