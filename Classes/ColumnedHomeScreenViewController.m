//
//  ColumnedHomeScreenViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "ColumnedHomeScreenViewController.h"

@interface ColumnedHomeScreenViewController ()

@property (atomic) UITableViewStyle myStyle;

@end

@implementation ColumnedHomeScreenViewController

@synthesize section;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.myStyle = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( [UIRefreshControl class] && [self.section respondsToSelector:@selector(refresh:)]) {
        UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self.section action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:[refreshControl autorelease]];
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg"]] autorelease];
    self.tableView.separatorColor = [UIColor clearColor];
    self.navigationItem.title = NSLocalizedString( [section title], @"" );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog( @"viewWillAppear" );
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog( @"viewWillDisAppear" );
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.section numberOfElements];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [section tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (UITableViewStyle)defaultStyle {
    return self.myStyle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [section selectRow:indexPath.row from:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [section rowHeight] + 5.0;
}

#pragma mark - Home

-(void)reloadSection:(id)section{
    NSLog( @"reload section" );
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
}

- (void)reloadByTimer {
    NSLog( @"Column:reloadByTimer" );
    [section reloadByTimer];
}

#pragma mark - child

- (void)didBecomeActive{
    NSLog( @"didBecomeActive" );
    [viewComposer changeDisplay:YES];
    [section reloadByTimer];
}


- (void)didResignActive{
    NSLog( @"didResignActive" );
    [viewComposer toDisappear];
}



@end
