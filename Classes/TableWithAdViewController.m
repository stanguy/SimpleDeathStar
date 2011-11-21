//
//  TableWithAdViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/18/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "TableWithAdViewController.h"

@implementation TableWithAdViewController
@synthesize tableView = tableView_;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)loadView {
    [super loadView];
    //    self.view = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.view = [arr objectAtIndex:0];
    tableView_ = [[UITableView alloc] initWithFrame:self.view.frame style:[self defaultStyle]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    viewComposer = [[ADViewComposer alloc] initWithView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    if ( indexPath ) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [viewComposer changeDisplay:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [viewComposer toDisappear];
}

- (UITableViewStyle)defaultStyle {
    return UITableViewStylePlain;
}

- (void)dealloc {
    self.view = nil;
    [tableView_ release]; tableView_ = nil;
    [viewComposer release]; viewComposer = nil;
    [super dealloc];
}

@end
