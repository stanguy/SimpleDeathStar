//
//  FavoritesSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "FavoritesHomeSection.h"

#import "Favorite.h"
#import "FavoritesViewController.h"
#import "FavTimeRelativeViewCell.h"
#import "FavTimeViewCell.h"
#import "Line.h"
#import "SimpleDeathStarAppDelegate.h"
#import "Stop.h"
#import "StopTime.h"
#import "StopTimeViewController.h"

@interface FavoritesHomeSection ()

- (void) reloadFavorites;

@end

@implementation FavoritesHomeSection

@synthesize topFavorites, favoriteTimes;

- (void)reloadByTimer {
    [self reloadFavorites];
}

-(id) init {
    self = [super init];
    topFavorites = [NSArray arrayWithObjects:nil];
    cachedFavoritesCount = 0;
    [self reloadFavorites];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavorites) name:@"favorites" object:nil];
    
    return self;
}

- (CGFloat)rowHeight {
    return 60.0f;
}

- (NSString*)title{
    return @"Favoris";
}

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    int topCount = [topFavorites count];
    
    // any favorite at all
    if ( topCount > 0 ) {
        if ( row < topCount ) {
            Favorite* fav = [topFavorites objectAtIndex:row];
            if ( (NSArray*)[NSNull null] == [favoriteTimes objectAtIndex:row] ) {
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
            [controller.navigationController pushViewController:stoptimeView animated:YES];
            [stoptimeView release];
        } else {
            FavoritesViewController* favViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
            [controller.navigationController pushViewController:favViewController animated:YES];
            [favViewController release];
            
        }
    }

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( 0 != buttonIndex) {
        // TODO I dunno what to do
        //        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        //Favorite* fav = [topFavorites objectAtIndex:indexPath.row];
        //[fav suicide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"favorites" object:nil];
    }
}

- (void)refresh:(UIRefreshControl*) control {
    [control beginRefreshing];
    [self reloadFavorites];
    [control endRefreshing];
}


- (void)reloadFavorites {
    cachedFavoritesCount = [Favorite count];
    NSInteger maxfit = [self bestMaxFitRows];
    if ( cachedFavoritesCount >= maxfit ) {
        maxfit--;
    }
    NSArray* favorites = [[Favorite topFavorites:maxfit] retain];
    NSMutableArray* favtimes = [[NSMutableArray alloc] initWithCapacity:[favorites count]];
    for ( Favorite* fav in favorites ) {
        [favtimes addObject:[StopTime findComingAt:fav]];
    }
    favoriteTimes = [favtimes retain];
    NSArray* oldFavorites = topFavorites;
    topFavorites = favorites;
    [oldFavorites release];
    [self.delegate reloadSection:self];
}

- (NSInteger)numberOfElements{
    int topCount = [topFavorites count];
    if ( cachedFavoritesCount > topCount ) {
        return topCount + 1;
    } else if ( topCount > 0 ) {
        return topCount;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Class favClass;
    SimpleDeathStarAppDelegate* delegate = (SimpleDeathStarAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (  [delegate useRelativeTime] ) {
        favClass = [FavTimeRelativeViewCell class];
    } else {
        favClass = [FavTimeViewCell class];
    }
    
    UITableViewCell *cell = nil;
    static NSString *CellIdentifierFavNone = @"CellFavNone";
    static NSString *CellIdentifierFav = @"CellFav";
    static NSString *CellIdentifierFavMore = @"CellFavMore";
    
    int topCount = [topFavorites count];
    
    if ( topCount > 0 ) {
        if ( indexPath.row >= topCount ) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFavMore];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierFavMore] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = NSLocalizedString( @"Voir tous les favoris", @"" );
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString( @"%d favoris enregistrés", @""), cachedFavoritesCount];
        } else {
            NSArray* times = nil;
            Favorite* fav = nil;
            fav = [topFavorites objectAtIndex:indexPath.row];
            times = [favoriteTimes objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFav];
            if( cell == nil ) {
                cell = [[[favClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierFav] autorelease];
            }
            ((FavTimeViewCell*)cell).favorite = fav;
            ((FavTimeViewCell*)cell).times = times;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFavNone];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierFavNone] autorelease];
        }
        cell.textLabel.text = NSLocalizedString( @"Aucun favori", @"" );
        cell.detailTextLabel.text = NSLocalizedString( @"Ajouter les depuis les pages d'horaires", @"");
    }
    return cell;
}



@end
