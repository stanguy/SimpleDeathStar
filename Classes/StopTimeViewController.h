//
//  StopTimeViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridScrollView.h"

@class Line;
@class Stop;
@class ADViewComposer;

@interface StopTimeViewController : UIViewController <NSFetchedResultsControllerDelegate,UIScrollViewDelegate, GridScrollViewDataSource, GridScrollViewListener, UIActionSheetDelegate> {
@private
    int timeShift_;
    NSDate* viewedDate_;
    
    UIAlertView* alertNoResult_;

    ADViewComposer* viewComposer;

}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIAlertView* alertNoResult;
@property (nonatomic, retain) Line* line;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) IBOutlet UIView* containerView;
@property (nonatomic, retain) IBOutlet GridScrollView *scrollView;	// holds floating grid
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* favButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* poiButton;
@property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, retain) UIView* dateChangeView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activity;
@property (nonatomic, retain) UIBarButtonItem* dateChangeItem;
@property (nonatomic, retain) UIBarButtonItem* refreshItem;

- (void)createFloatingGrid;
- (void)adjustScrollViewFrame;
- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column;
- (void)alignGridAnimated:(BOOL)animated;
- (IBAction)shiftLeft:(id)sender;
- (IBAction)shiftRight:(id)sender;

- (IBAction)changeDate:(id)sender;
- (IBAction)onDismissChangeDate:(id)sender;
- (IBAction)onChangeDate:(id)sender;

- (IBAction)showPoi:(id)sender;

- (IBAction)toggleFavorite:(id)sender;
- (void)reloadData;
@end
