//
//  TripViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/06/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "TripViewController.h"
#import "StopTime.h"
#import "Stop.h"
#import "Line.h"
#import "Direction.h"


@implementation TripViewController

@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize stopTime = stopTime_;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = [NSString stringWithFormat:@"%@ vers %@", stopTime_.line.short_name, stopTime_.direction.headsign];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    StopTime* stopTime = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.detailTextLabel.text = stopTime.stop.name;
    int arrival = [stopTime.arrival intValue] / 60;
    int mins = arrival % 60;
    int hours = ( arrival / 60 ) % 24;
    cell.textLabel.text = [NSString stringWithFormat:@"%02d:%02d", hours, mins];
    
    return cell;
}

- (NSFetchedResultsController*) fetchedResultsController {
    if (nil != fetchedResultsController_) {
        return fetchedResultsController_;
    }
    fetchedResultsController_ = [[StopTime findFollowing:stopTime_]retain];
    return fetchedResultsController_;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

