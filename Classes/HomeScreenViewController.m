//
//  HomeScreenViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "LineViewController.h"
#import "StopViewController.h"
#import "CityViewController.h"
#import "AboutViewController.h"
#import "Line.h"

@implementation HomeScreenViewController

NSString* menuTitles[] = {
    @"Recherche par lignes",
    @"Recherche par arrêt",
    @""
};
int LineMenuValues[] = {
    LINE_USAGE_URBAN,
    LINE_USAGE_SUBURBAN,
    LINE_USAGE_EXPRESS,
    LINE_USAGE_SPECIAL,
    LINE_USAGE_ALL,
    -1
};
int AboutMenuValues[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    -1
};

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Accueil";
    menus_ = [[NSMutableArray alloc] init];
    [menus_ addObject:[NSArray arrayWithObjects: @"Lignes urbaines", @"Lignes suburbaines", @"Lignes express", @"Lignes spéciales", @"Toutes les lignes", /*@"Favorites",*/ nil ]];
    [menus_ addObject:[NSArray arrayWithObjects: @"Arrêts par ville",@"Tous les arrêts", /*@"Favoris",*/ nil]];
    [menus_ addObject:[NSArray arrayWithObjects: @"À propos", @"Pas de panique", nil ]];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sizeof(menuTitles) / sizeof(NSString*);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[menus_ objectAtIndex:section] count];
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
    cell.textLabel.text = [[menus_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return menuTitles[section];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    if ( indexPath.section == 0 ) {
        if ( LineMenuValues[indexPath.row] > 0 ) {
            LineViewController* lineViewController = [[LineViewController alloc] initWithNibName:@"LineViewController" bundle:nil];
            lineViewController.usageType = LineMenuValues[indexPath.row];
            [self.navigationController pushViewController:lineViewController animated:YES];
            [lineViewController release];
        }
    } else if ( indexPath.section ==1 ) {
        if ( indexPath.row == 0 ) {
            CityViewController* cityViewController = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
            [self.navigationController pushViewController:cityViewController animated:YES];
            [cityViewController release];
        } else {
        StopViewController* stopViewController = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
        [self.navigationController pushViewController:stopViewController animated:YES];
        [stopViewController release];
        }
    } else if (indexPath.section == 2) {
        AboutViewController* aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        aboutVC.type = AboutMenuValues[indexPath.row];
        [self.navigationController pushViewController:aboutVC animated:YES];
        [aboutVC release];
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
    [menus_ release];
    [super dealloc];
}


@end

