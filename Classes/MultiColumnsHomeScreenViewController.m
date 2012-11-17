//
//  MultiColumnsHomeScreenViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "MultiColumnsHomeScreenViewController.h"

#import "CloseStopsHomeSection.h"
#import "ColumnedHomeScreenViewController.h"
#import "FavoritesHomeSection.h"
#import "LineTypesHomeSection.h"
#import "StopsHomeSection.h"
#import "HelpHomeSection.h"


@interface MultiColumnsHomeScreenViewController ()

@end

@implementation MultiColumnsHomeScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray* columns = [[[NSMutableArray alloc] init] autorelease];
        NSArray* sectionClasses = [NSArray arrayWithObjects:[LineTypesHomeSection class], [StopsHomeSection class], [FavoritesHomeSection class], [CloseStopsHomeSection class],  [HelpHomeSection class], nil];
        for (Class class in sectionClasses) {
            AbstractHomeSection* section = [[class alloc] init];
            ColumnedHomeScreenViewController* column = [[ColumnedHomeScreenViewController alloc] init];
            column.section = section;
            section.delegate = column;
            [columns addObject:column];
        }
        self.viewControllers = columns;
        viewComposer = [[ADViewComposer alloc] initWithView:self.scrollView];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Home

- (void)reloadByTimer
{}

@end
