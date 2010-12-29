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
@class GridScrollView;
@protocol GridScrollViewDataSource;

@interface StopTimeViewController : UIViewController <NSFetchedResultsControllerDelegate,UIScrollViewDelegate, GridScrollViewDataSource> {
@private
    NSFetchedResultsController *fetchedResultsController_;
    Line* line_;
    Stop* stop_;
    
    GridScrollView *scrollView;	// holds floating grid
    UITableView *tableView;

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Line* line;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) IBOutlet GridScrollView *scrollView;	// holds floating grid
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)createFloatingGrid;
- (void)adjustScrollViewFrame;
- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column;
- (void)alignGridAnimated:(BOOL)animated;
@end
