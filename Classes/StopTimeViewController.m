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
#import "GridScrollView.h"

#import "SimpleDeathStarAppDelegate.h"


const int kRowHeight = 50;
const int kCellWidth = 44;


@implementation StopTimeViewController

@synthesize fetchedResultsController = fetchedResultsController_, line = line_, stop = stop_;
@synthesize tableView, scrollView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.scrollView.tileWidth  = kCellWidth;
    self.scrollView.tileHeight = kRowHeight;
    self.view.clipsToBounds = YES;
    self.tableView.scrollEnabled = NO;
    [self createFloatingGrid];
    
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
        
    NSString *stopName = [[[self.fetchedResultsController sections] objectAtIndex:indexPath.row] name];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.text =  stopName;
    cell.detailTextLabel.text =  @" ";
    
    return cell;
}


- (NSFetchedResultsController*) fetchedResultsController {
    if ( nil != fetchedResultsController_) {
        return fetchedResultsController_;
    }
    fetchedResultsController_ = [StopTime findByLine:line_ andStop:stop_];
    [fetchedResultsController_ retain];
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
    NSLog( @"createFloatingGrid" );
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
    scrollView.frame = CGRectMake(6, 0, 320, self.view.frame.size.height); 
    
}

- (UIView *)gridScrollView:(GridScrollView *)scrollView tileForRow:(int)row column:(int)column {
    if ( row >= [[self.fetchedResultsController sections] count] ) {
        return nil;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:row];
    if( column >= [sectionInfo numberOfObjects] ) {
        return nil;
    }
    
    
    UIView *cellview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kRowHeight)];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:11.0];
    // fill
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:column inSection:row];
    StopTime* st = [self.fetchedResultsController objectAtIndexPath:indexPath];
    int arrival = [st.arrival intValue] / 60;
    int mins = arrival % 60;
    int hours = ( arrival / 60 ) % 24;
    label.text = [NSString stringWithFormat:@"%02d:%02d", hours, mins];    
    
    label.backgroundColor = [UIColor clearColor];
    
    if (column % 2 == 0) {
        cellview.backgroundColor = [UIColor clearColor];
    } else {
        cellview.backgroundColor = [UIColor colorWithRed: (214/255.0) green: (214/255.0) blue: (255/255.0) alpha: 0.3];
    }
    
    label.frame = CGRectMake(8, 15, kCellWidth, kRowHeight - 15);
    [cellview addSubview:label];
    [label release];
    
    [cellview autorelease];
    return (UIView *)cellview; 
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
    [super dealloc];
}


@end

