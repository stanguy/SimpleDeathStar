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
#import "HomeScreenViewController.h"
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
        NSMutableArray* columns = [NSMutableArray array];
        [columns addObject:[[[HomeScreenViewController alloc] initWithHomeStyle:kHomeStyleStart] autorelease]];
        NSArray* sectionClasses = [NSArray arrayWithObjects:[FavoritesHomeSection class], [CloseStopsHomeSection class], nil];
        for (Class class in sectionClasses) {
            AbstractHomeSection* section = [[class alloc] init];
            ColumnedHomeScreenViewController* column = [[ColumnedHomeScreenViewController alloc] initWithStyle:UITableViewStylePlain];
            column.section = section;
            section.delegate = column;
            [columns addObject:[column autorelease]];
        }
        [columns addObject:[[[HomeScreenViewController alloc] initWithHomeStyle:kHomeStyleHelp] autorelease]];
        for ( TableWithAdViewController* children in columns ) {
            children.skipComposingOnEvents = YES;
        }
        self.viewControllers = columns;
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
{
    UIViewController* currentController = [self.viewControllers objectAtIndex:self.pageControl.currentPage];
    if ( nil != currentController && [currentController respondsToSelector:@selector(reloadByTimer)]) {
        [currentController performSelector:@selector(reloadByTimer)];
    }
}

@end
