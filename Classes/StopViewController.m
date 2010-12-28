//
//  StopViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "StopViewController.h"
#import "Line.h"
#import "Stop.h"
#import "City.h"
#import "StopTimeViewController.h"

@implementation StopViewController

@synthesize line = line_;
@synthesize city = city_;
@synthesize stops = stops_;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ( self.line != nil ) {
        self.navigationItem.title = self.line.long_name;
    } else if ( self.city != nil ) {
        self.navigationItem.title = self.city.name;
    } else {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.delegate = self; 
        searchBar.placeholder = @"Arrêt à rechercher";
        
        self.navigationItem.titleView = searchBar;
        self.navigationItem.titleView.frame = CGRectMake(0, 0, 325, 44);
        
        [searchBar release];
    }
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.stops count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    Stop* stop = [[self stops] objectAtIndex:indexPath.row];
    cell.textLabel.text = stop.name;
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
    stoptimeView.line = self.line;
    stoptimeView.stop = [[self stops] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:stoptimeView animated:YES];
    [stoptimeView release];
}

- (NSArray*)stops {
    if (stops_ != nil ) {
        return stops_;
    }
    NSSortDescriptor *sortNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortNameDescriptor, nil] autorelease];
    
    NSArray *objects;
    if (self.line != nil) {
        objects = [self.line.stops allObjects];
    } else if ( self.city != nil) {
        objects = [self.city.stops allObjects];
    } else {
        objects = [[Stop findAll] fetchedObjects];
    }
    stops_ = [objects sortedArrayUsingDescriptors:sortDescriptors];
    [stops_ retain];
    return stops_;
}

#pragma mark -
#pragma mark searchBar

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated: YES];
    return YES;
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    NSLog( @"searching %@", text );
    NSSortDescriptor *sortNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortNameDescriptor, nil] autorelease];
    [stops_ release];
    if ( [text length] > 0 ) {
        stops_ = [[[Stop findByName:text] fetchedObjects] sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        stops_ = [[[Stop findAll] fetchedObjects] sortedArrayUsingDescriptors:sortDescriptors];
    }
    [stops_ retain];
    [self.tableView reloadData];
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

