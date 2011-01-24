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
@protocol GridScrollViewListener;

@interface StopTimeViewController : UIViewController <NSFetchedResultsControllerDelegate,UIScrollViewDelegate, GridScrollViewDataSource, GridScrollViewListener> {
@private
    NSFetchedResultsController *fetchedResultsController_;
    Line* line_;
    Stop* stop_;
    int timeShift_;
    NSDate* viewedDate_;
    
    GridScrollView *scrollView;	// holds floating grid
    UITableView *tableView;
    UIView* noResultView;
    UIToolbar* toolbar_;
    UIBarButtonItem* favButton_;

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Line* line;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) IBOutlet GridScrollView *scrollView;	// holds floating grid
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* favButton;

- (void)createFloatingGrid;
- (void)adjustScrollViewFrame;
- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column;
- (void)alignGridAnimated:(BOOL)animated;
- (IBAction)shiftLeft:(id)sender;
- (IBAction)shiftRight:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)toggleFavorite:(id)sender;
- (void)delayChangeDateInLabel:(id)sender;
- (void)changeDateInLabel:(id)sender;
- (void)reloadData;
@end
