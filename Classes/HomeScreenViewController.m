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
#import "Favorite.h"
#import "Line.h"

@implementation HomeScreenViewController

NSString* menuTitles[] = {
    @"Recherche par lignes",
    @"Recherche par arrêt",
    @"Favoris",
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

enum eSections {
    kLineSection,
    kStopsSection,
    kFavoritesSection,
    kAboutSection
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
    [menus_ addObject:[NSArray arrayWithObjects:nil]];
    [menus_ addObject:[NSArray arrayWithObjects: @"À propos", @"Pas de panique", @"Sur le web", nil ]];
    
    topFavorites_ = [Favorite topFavorites];
    cachedFavoritesCount = [Favorite count];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sizeof(menuTitles) / sizeof(NSString*);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ( section != kFavoritesSection )
        return [[menus_ objectAtIndex:section] count];
    else {
        int topCount = [topFavorites_ count];
        if ( cachedFavoritesCount > topCount ) {
            return topCount + 1;
        } else if ( topCount > 0 ) {
            return topCount;
        } else {
            return 1;
        }
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierFav = @"CellFav";
    static NSString *CellIdentifierFavNone = @"CellFavNone";
    static NSString *CellIdentifierFavMore = @"CellFavMore";
    UITableViewCell *cell;
    if ( indexPath.section != kFavoritesSection ) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    // Configure the cell...
        cell.textLabel.text = [[menus_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {

        int topCount = [topFavorites_ count];
        
        if ( topCount > 0 ) {
            NSString* ident;
            NSString* txt;
            NSString* subtxt;
            if ( indexPath.row >= topCount ) {
                ident = CellIdentifierFavMore;
                txt = @"Voir tous les favoris";
                subtxt = [NSString stringWithFormat:@"%d favoris enregistrés", cachedFavoritesCount];
            } else {
                ident = CellIdentifierFav;
                Favorite* fav = [topFavorites_ objectAtIndex:indexPath.row];
                txt = [fav title];
                subtxt = @"12:42, 12:54, 13:01";

            }
            cell = [tableView dequeueReusableCellWithIdentifier:ident];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = txt;
            cell.detailTextLabel.text = subtxt;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFavNone];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierFavNone] autorelease];
            }
            cell.textLabel.text = @"Aucun favori";
            cell.detailTextLabel.text = @"Ajouter les depuis les pages d'horaires";
        }

    }

    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return menuTitles[section];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    switch ( indexPath.section) {
        case kLineSection:
            if ( LineMenuValues[indexPath.row] > 0 ) {
                LineViewController* lineViewController = [[LineViewController alloc] initWithNibName:@"LineViewController" bundle:nil];
                lineViewController.usageType = LineMenuValues[indexPath.row];
                [self.navigationController pushViewController:lineViewController animated:YES];
                [lineViewController release];
            }
            break;
        case kStopsSection:
            if ( indexPath.row == 0 ) {
                CityViewController* cityViewController = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
                [self.navigationController pushViewController:cityViewController animated:YES];
                [cityViewController release];
            } else {
                StopViewController* stopViewController = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
                [self.navigationController pushViewController:stopViewController animated:YES];
                [stopViewController release];
            }
            break;
        case kFavoritesSection:
            break;
        case kAboutSection:
        {
            if ( indexPath.row < 2 ) {
                AboutViewController* aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                aboutVC.type = AboutMenuValues[indexPath.row];
                [self.navigationController pushViewController:aboutVC animated:YES];
                [aboutVC release];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.dthg.net"]];
            }

        }
            break;
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

