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

#import "SimpleDeathStarAppDelegate.h"

@implementation StopTimeViewController

@synthesize fetchedResultsController = fetchedResultsController_, line = line_, stop = stop_;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    StopTime* st = [self.fetchedResultsController objectAtIndexPath:indexPath];
    int arrival = [st.arrival intValue] / 60;
    int mins = arrival % 60;
    int hours = ( arrival / 60 ) % 24;
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%d:%02d", hours, mins];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name]; 
}  


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
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

