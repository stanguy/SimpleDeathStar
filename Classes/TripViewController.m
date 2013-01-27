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
#import "TripViewCell.h"
#import "Line.h"
#import "Direction.h"
#import "StopTimeFormatter.h"


@implementation TripViewController

@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize stopTime = stopTime_;
@synthesize time_formatter;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString( @"%@ vers %@", @"" ), stopTime_.line.short_name, stopTime_.direction.headsign];
    self.time_formatter = [[StopTimeFormatter alloc] init];
    self.time_formatter.relative = false;
    self.time_formatter.time_type = STOPTIME_ARRIVAL;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
    
    TripViewCell *cell = [TripViewCell cellFromNibNamed:@"TripViewCell"];
    
    // Configure the cell...
    StopTime* stopTime = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Stop* stop = stopTime.stop;
    Line* line = stopTime.line;

    cell.arrivalTime.text = [self.time_formatter format:stopTime];
    cell.stopName.text = stop.name;
    cell.metro.hidden = [stop.metro_count intValue] == 0;
    cell.bike.hidden = [stop.bike_count intValue] == 0;
    cell.pos.hidden = [stop.pos_count intValue] == 0;
    cell.accessible.hidden = ! ( [stop.accessible intValue] && [line.accessible intValue] );

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

