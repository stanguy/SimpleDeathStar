//
//  TableWithAdViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/18/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "TableWithAdViewController.h"

@interface TableWithAdViewController () {
}
@end


@implementation TableWithAdViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.skipComposingOnEvents = NO;
    }
    
    return self;
}

-(void)loadView {
    //    NSLog( @"loadView" );
    if ( nil != self.nibName ) {
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.view = [arr objectAtIndex:0];
    } else {
        self.view = [[[UIView alloc] init] autorelease];
        self.tableView = [[[UITableView alloc] initWithFrame:self.view.frame style:[self defaultStyle]] autorelease];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    viewComposer = [[ADViewComposer alloc] initWithView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    //    NSLog( @"viewWillAppear %@", self );
    [super viewWillAppear:animated];
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    if ( indexPath ) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if ( ! self.skipComposingOnEvents ) {
        [viewComposer changeDisplay:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //    NSLog( @"viewWillDisAppear %@", self );
    if ( ! self.skipComposingOnEvents ) {
        [viewComposer toDisappear];
    }
}

- (UITableViewStyle)defaultStyle {
    return UITableViewStylePlain;
}

- (void)dealloc {
    self.view = nil;
    [viewComposer release]; viewComposer = nil;
    [super dealloc];
}

@end
