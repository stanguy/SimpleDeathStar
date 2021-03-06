//
//  HomeScreenViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "HomeScreenViewController.h"

#import "CloseStopsHomeSection.h"
#import "FavoritesHomeSection.h"
#import "LinesHomeSection.h"
#import "LineTypesHomeSection.h"
#import "StopsHomeSection.h"
#import "HelpHomeSection.h"


@interface HomeScreenViewController () {
    int homeStyle;
}

@property (retain) UIView* footer;

@end


@implementation HomeScreenViewController;

@synthesize sections, footer;
#pragma mark -

-(id)initWithHomeStyle:(HomeStyle)style {
    self = [super init];
    if ( self ) {
        homeStyle = style;
    }
    return self;
}

- (UITableViewStyle)defaultStyle {
    return UITableViewStyleGrouped;
}

#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString( @"Accueil", @"" );
    
    NSMutableArray* buildSections = [[[NSMutableArray alloc] init] autorelease];
    NSArray* sectionClasses;
    
    switch ( homeStyle ) {
        case kHomeStyleStart:
#ifndef VERSION_STLO
            sectionClasses = [NSArray arrayWithObjects:
                              [[[LineTypesHomeSection alloc] init] autorelease],
                              [[[StopsHomeSection alloc] init] autorelease], nil];
#else
            sectionClasses = [NSArray arrayWithObjects:
                              [[[LinesHomeSection alloc] init] autorelease],
                              [[[StopsHomeSection alloc] init] autorelease], nil];
#endif
            break;
        default:
        case kHomeStyleHelp:
            self.navigationItem.title = NSLocalizedString( @"Aide", @"" );
            sectionClasses = [NSArray arrayWithObjects:
                              [[[HelpHomeSection alloc] initWithType:kHelpLocal] autorelease],
                              [[[HelpHomeSection alloc] initWithType:kHelpRemote] autorelease],
                              nil];
            break;
        case kHomeStyleFull:
#ifndef VERSION_STLO
            sectionClasses = [NSArray arrayWithObjects:
                              [[[LineTypesHomeSection alloc] init] autorelease],
                              [[[StopsHomeSection alloc] init] autorelease],
                              [[[FavoritesHomeSection alloc] init] autorelease],
                              [[[CloseStopsHomeSection alloc] init] autorelease],
                              [[[HelpHomeSection alloc] init] autorelease], nil];
#else
            sectionClasses = [NSArray arrayWithObjects:
                              [[[FavoritesHomeSection alloc] init] autorelease],
                              [[[CloseStopsHomeSection alloc] init] autorelease],
                              [[[LinesHomeSection alloc] init] autorelease],
                              [[[StopsHomeSection alloc] init] autorelease],
                              [[[HelpHomeSection alloc] init] autorelease]
                              ,nil];
#endif
            break;
            
    }
    for ( AbstractHomeSection* section in sectionClasses) {
        section.delegate = self;
        [buildSections addObject:section];
    }
    
    self.sections = buildSections;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark -
#pragma mark local stuff


-(void)reloadSection:(id)section{
    NSIndexSet* set = nil;
    int i = 0;
    for ( AbstractHomeSection* existingSection in self.sections ) {
        if ( existingSection == section ) {
            set = [NSIndexSet indexSetWithIndex:i];
            break;
        }
        ++i;
    }
    if ( nil != set ) {
        [self.tableView reloadSections:set withRowAnimation:YES];
    }
}

- (void)reloadByTimer {
    for ( AbstractHomeSection* section in self.sections) {
        [section reloadByTimer];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [sections count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AbstractHomeSection* section = [self.sections objectAtIndex:indexPath.section];
    if ( [section respondsToSelector:@selector(rowHeight)]) {
        return [section rowHeight];
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LineTypesHomeSection* sectionObj = [sections objectAtIndex:section];
    return [sectionObj numberOfElements] ;
}
    

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[sections objectAtIndex:indexPath.section] tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString( [[sections objectAtIndex:section] title], nil);
}

#pragma mark - child

- (void)didBecomeActive{
    //    NSLog( @"didBecomeActive" );
    [viewComposer changeDisplay:YES];
}


- (void)didResignActive{
    //    NSLog( @"didResignActive" );
    [viewComposer toDisappear];
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.sections objectAtIndex:indexPath.section] selectRow:indexPath.row from:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ( homeStyle == kHomeStyleStart ) {
        if ( ( section + 1 ) == [sections count] ) {
            if ( ! self.footer ) {
                CGRect footerFrame = [tableView rectForFooterInSection:1];
                CGRect labelFrame = CGRectMake( 15, 10, footerFrame.size.width - 40, footerFrame.size.height - 20);
                
                self.footer = [[[UIView alloc] initWithFrame:footerFrame] autorelease];
                UILabel *footerLabel = [[UILabel alloc] initWithFrame:labelFrame];
                
                [footer addSubview:footerLabel];
                [footerLabel release];
                footerLabel.font = [UIFont systemFontOfSize:9.0];
                footerLabel.text = NSLocalizedString( @"Faites glisser latéralement pour retrouver favoris et autres...", @"" );
                footerLabel.backgroundColor = [UIColor clearColor];
            }
            return self.footer;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ( homeStyle != kHomeStyleFull ) {
        if ( ( section + 1 ) == [sections count] ) {
            return 40.0f;
        }
    }
    return 0.0f;
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

