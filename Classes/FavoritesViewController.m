//
//  FavoritesViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/26/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavTimeViewCell.h"
#import "StopTime.h"
#import "StopTimeViewController.h"
#import "Favorite.h"
#import "Line.h"
#import "Stop.h"

@implementation FavoritesViewController

@synthesize fetchedResultsController = fetchedResultsController_;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString( @"Favoris", @"" );
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataChange) name:@"favorites" object:nil];
}

-(void)handleDataChange {
    [fetchedResultsController_ release];
    fetchedResultsController_ = nil;
    [self.tableView reloadData];
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
    
    static NSString *CellIdentifier = @"CellFav";
    
    Favorite* fav = [self.fetchedResultsController objectAtIndexPath:indexPath];
    FavTimeViewCell *cell = (FavTimeViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( cell == nil ) {
        cell = [[[FavTimeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.favorite = fav;
    cell.times = [StopTime findComingAt:fav];
        
    return cell;
}


- (NSFetchedResultsController*) fetchedResultsController {
    if (nil != fetchedResultsController_) {
        return fetchedResultsController_;
    }
    fetchedResultsController_ = [Favorite findAll];
    [fetchedResultsController_ retain];
    return fetchedResultsController_;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorite* fav = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ( (NSArray*)[NSNull null] == [StopTime findComingAt:fav] ) {
        // try to fix or remove it
        if ( [fav couldUpdateReferences] ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Mise à jour", @"" )
                                                            message:NSLocalizedString( @"Ce favori a été mis à jour", @"" )
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Erreur", @"" )
                                                            message:NSLocalizedString( @"Ce favori n'est plus valide", @"" )
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString( @"Annuler", @"" )
                                                  otherButtonTitles:NSLocalizedString( @"Supprimer", @"" ), nil];
            [alert show];
            [alert release];
        }
        return;
    }
    StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
    stoptimeView.line = [Line findFirstBySrcId:fav.line_id];
    stoptimeView.stop = [Stop findFirstBySrcId:fav.stop_id];
    [self.navigationController pushViewController:stoptimeView animated:YES];
    [stoptimeView release];         
}

// TODO Duplicate!
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( 0 != buttonIndex) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        Favorite* fav = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [fav suicide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
    }
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

