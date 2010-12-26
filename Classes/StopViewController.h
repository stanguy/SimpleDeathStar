//
//  StopViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Line;


@interface StopViewController : UITableViewController {
@private
    Line* line_;

}
@property (nonatomic, retain) Line* line;

@end
