//
//  StopTimeViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Line;
@class Stop;

@interface StopTimeViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
@private
    NSFetchedResultsController *fetchedResultsController_;
    Line* line_;
    Stop* stop_;
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Line* line;
@property (nonatomic, retain) Stop* stop;
@end
