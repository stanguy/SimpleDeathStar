//
//  StopTimeViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "StopTimeViewController.h"
#import "Line.h"
#import "Stop.h"
#import "StopTime.h"
#import "Direction.h"
#import "GridScrollView.h"
#import "TripViewController.h"
#import "Favorite.h"

#import "SimpleDeathStarAppDelegate.h"


const int kRowHeight = 50;
const int kCellWidth = 46;


@implementation StopTimeViewController

@synthesize fetchedResultsController = fetchedResultsController_, line = line_, stop = stop_;
@synthesize tableView, scrollView, toolbar = toolbar_, favButton = favButton_, alertNoResult = alertNoResult_, datePicker = datePicker_;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    timeShift_ = 0;
    viewedDate_ = [NSDate date];
    [viewedDate_ retain];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.scrollView.tileWidth  = kCellWidth;
    self.scrollView.tileHeight = kRowHeight;
    self.view.clipsToBounds = YES;
    self.tableView.scrollEnabled = NO;
    [self createFloatingGrid];
    
    if ( self.line != nil && self.stop != nil ) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ / %@", self.line.short_name, self.stop.name];
    } else if ( self.stop != nil ) {
        self.navigationItem.title = self.stop.name;
    }
        
    if ( [Favorite existsWithLine:line_ andStop:stop_] ) {
        favButton_.image = [UIImage imageNamed:@"favorites_remove"];
    } else {
        favButton_.image = [UIImage imageNamed:@"favorites_add"];
    }
}

- (UIAlertView*)alertNoResult {
    if ( alertNoResult_ != nil ) {
        return alertNoResult_;
    }
    alertNoResult_ = [[[UIAlertView alloc] initWithTitle:@"Aucun passage" 
                                                message:@"Aucun passage prévu à la date indiquée" 
                                               delegate:nil 
                                      cancelButtonTitle:@"Ok" 
                                      otherButtonTitles:nil] retain];
    return alertNoResult_;
}    

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.fetchedResultsController sections] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GridCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.accessoryType =  UITableViewCellAccessoryNone; 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id<NSFetchedResultsSectionInfo> section = [[self.fetchedResultsController sections] objectAtIndex:indexPath.row];
    StopTime* st = [[section objects] objectAtIndex:0];
    NSString *directionName = st.direction.headsign;
    if ( line_ == nil ) {
        directionName = [NSString stringWithFormat:@"%@ vers %@", st.line.short_name, directionName];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.text =  directionName;
    cell.detailTextLabel.text =  @" ";
    
    return cell;
}


- (NSFetchedResultsController*) fetchedResultsController {
    if ( nil != fetchedResultsController_) {
        return fetchedResultsController_;
    }
    fetchedResultsController_ = [StopTime findByLine:line_ andStop:stop_ atDate:viewedDate_];
    [fetchedResultsController_ retain];
    if ( [[fetchedResultsController_ sections] count] < 1 ) {
        
/*        */
        // optional - add more buttons:
        NSLog( @"no result show %@", self.alertNoResult );
        [self.alertNoResult show];
    }
    
    return fetchedResultsController_;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

#pragma mark -
#pragma mark GridScrollView

- (void)createFloatingGrid {
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    self.scrollView.hidden = YES;
    
    int nb_max_stops = 0;
    int nbStops = [[self.fetchedResultsController sections] count];
    if (nbStops == 0) {
        return;
    }
    for ( int i = 0; i < nbStops ; ++i) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
        if ( [sectionInfo numberOfObjects] > nb_max_stops) {
            nb_max_stops = [sectionInfo numberOfObjects];
        }
    }
    int gridWidth = (nb_max_stops * kCellWidth) + 12;
    int gridHeight = (nbStops * kRowHeight);
    [scrollView setContentSize:CGSizeMake(gridWidth, gridHeight)];
    
    [self adjustScrollViewFrame];
    [self.view bringSubviewToFront:scrollView];
    
    //    [self.view addSubview:scrollView];
    
    [scrollView reloadData];    
}

- (void)adjustScrollViewFrame {
    scrollView.frame = CGRectMake(6, 0, 320, self.view.frame.size.height - self.toolbar.frame.size.height); 
    
}

- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column {
    if ( row >= [[self.fetchedResultsController sections] count] ) {
        return nil;
    }
    UIView *cellview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kRowHeight)];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12.0];
    // fill
    
    if ( column >= [ [[self.fetchedResultsController sections] objectAtIndex:row] numberOfObjects] ) {
        label.text =  @"\u2014:\u2014";
    } else {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:column inSection:row];
        StopTime* st = [self.fetchedResultsController objectAtIndexPath:indexPath];
             
        label.text = [st formatArrival];
    }

    
    label.backgroundColor = [UIColor clearColor];
    
    if (column % 2 == 0) {
        cellview.backgroundColor = [UIColor clearColor];
    } else {
        cellview.backgroundColor = [UIColor colorWithRed: (214/255.0) green: (214/255.0) blue: (255/255.0) alpha: 0.3];
    }
    
    label.frame = CGRectMake(8, 15, kCellWidth, kRowHeight - 15);
    [cellview addSubview:label];
    [label release];
    
   
    return [cellview autorelease]; 
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    tableView.contentOffset = CGPointMake(0, aScrollView.contentOffset.y);
    self.scrollView.directionalLockEnabled = YES; // I don't know why this keeps getting set to NO otherwise
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self alignGridAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self alignGridAnimated:YES];
}

- (void)alignGridAnimated:(BOOL)animated {
    float x = self.scrollView.contentOffset.x;
    float y = self.scrollView.contentOffset.y;
    float maxY = self.scrollView.contentSize.height - self.scrollView.frame.size.height - (kRowHeight / 2);
    
    if (y == self.scrollView.contentSize.height - self.scrollView.frame.size.height) {
        return;
        
    }
    // when at bottom, align toward bottom, except when too few rows
    float newY;
    if ( (y > maxY ) &&  (maxY >= self.scrollView.frame.size.height) )   {
        newY = self.scrollView.contentSize.height - self.scrollView.frame.size.height + 10;
    } else {
        newY = round(y/kRowHeight) * kRowHeight;
    }
    CGPoint contentOffset = CGPointMake( (round(x/kCellWidth) * kCellWidth), newY);
    
    [self.scrollView setContentOffset:contentOffset animated:animated];        
}

- (void)touchedRowAndCol:(NSArray*)rowAndCol {
    int row = [[rowAndCol objectAtIndex:0] intValue];
    int col = [[rowAndCol objectAtIndex:1] intValue];
    NSArray* sections = [self.fetchedResultsController sections];
    if ( row >= [sections count] ) {
        return;
    }
    id<NSFetchedResultsSectionInfo> section = [sections objectAtIndex:row];
    if ( col >= [section numberOfObjects] ) {
        return;
    }
    StopTime* st = [[section objects] objectAtIndex:col];
    NSLog( @"touched %dx%d: %@", row, col, st );
    TripViewController* tripViewController = [[TripViewController alloc] initWithNibName:@"TripViewController" bundle:nil];
    tripViewController.stopTime = st;
    [self.navigationController pushViewController:tripViewController animated:YES];
    [tripViewController release];
}

- (void)doubleTouchedRowAndCol:(NSArray*)rowAndCol {
//    int row = [[rowAndCol objectAtIndex:0] intValue];
    int col = [[rowAndCol objectAtIndex:1] intValue];
    int nb_max_stops = 0;
    int nbStops = [[self.fetchedResultsController sections] count];
    if (nbStops == 0) {
        return;
    }
    for ( int i = 0; i < nbStops ; ++i) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
        if ( [sectionInfo numberOfObjects] > nb_max_stops) {
            nb_max_stops = [sectionInfo numberOfObjects];
        }
    }
    int max_cell_by_width = [[UIScreen mainScreen] bounds].size.width / kCellWidth;
    int ref_col = nb_max_stops > max_cell_by_width ? nb_max_stops : max_cell_by_width;
    if ( col >= ref_col - 2 ) {
        [self shiftRight:nil];
    } else if ( col <= 2 ) {
        [self shiftLeft:nil];
    }
}

-(void)changeDate:(id)sender {
    if ( dateChangeView_ == nil ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DateNavigation" owner:self options:nil];
        NSEnumerator *enumerator = [nib objectEnumerator];
        id object;
        while ((object = [enumerator nextObject])) {
            if ([object isMemberOfClass:[UIView class]]) {
                dateChangeView_ = (UIView*) object;
            }
        }
        [self.view addSubview:dateChangeView_]; 
    }
    self.datePicker.date = viewedDate_;
    [self.view bringSubviewToFront:dateChangeView_];
}

-(void)onChangeDate:(id)sender {
    [self.view sendSubviewToBack:dateChangeView_];
    [viewedDate_ release];
    viewedDate_ = [self.datePicker.date retain];
    NSLog( @"date: %@", viewedDate_ );
    [self reloadData];    
}
- (void)onDismissChangeDate:(id)sender {
    [self.view sendSubviewToBack:dateChangeView_];
}


#pragma mark -
#pragma mark Others

- (IBAction)shiftLeft:(id)sender {
    [self.view sendSubviewToBack:dateChangeView_];
    NSDate* tmpDate = [[viewedDate_ dateByAddingTimeInterval:-BASE_TIMESHIFT] retain];
    [viewedDate_ release];
    viewedDate_ = tmpDate;
    [self reloadData];
}
- (IBAction)shiftRight:(id)sender {
    [self.view sendSubviewToBack:dateChangeView_];
    NSDate* tmpDate = [[viewedDate_ dateByAddingTimeInterval:BASE_TIMESHIFT] retain];
    [viewedDate_ release];
    viewedDate_ = tmpDate;
    [self reloadData];
}

- (void)reloadData {
    [self.fetchedResultsController release];
    fetchedResultsController_ = nil;
    [self.tableView reloadData];
    [self.scrollView reloadData];
    [self createFloatingGrid];
}


- (IBAction)toggleFavorite:(id)sender {

    if ( [Favorite existsWithLine:line_ andStop:stop_] ) {
        // remove
        [Favorite deleteWithLine:line_ andStop:stop_];
        favButton_.image = [UIImage imageNamed:@"favorites_add"];
    } else {
        // create new favorite
        [Favorite addWithLine:line_ andStop:stop_];
        favButton_.image = [UIImage imageNamed:@"favorites_remove"];
    }
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [alertNoResult_ release];
    [viewedDate_ release];
    [super dealloc];
}


@end

