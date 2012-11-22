//
//  ColumnedHomeScreenViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "ColumnedHomeScreenViewController.h"

@interface ColumnedHomeScreenViewController ()

@end

@implementation ColumnedHomeScreenViewController

@synthesize section;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:223.0/255.0 alpha:1.0];
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
    cell.backgroundColor = [UIColor whiteColor];    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [section tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (UITableViewStyle)defaultStyle {
    return UITableViewStylePlain;
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
}


- (void)didResignActive{
    NSLog( @"didResignActive" );
    [viewComposer toDisappear];
}



@end
