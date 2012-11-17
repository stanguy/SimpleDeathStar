//
//  LineHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "LineTypesHomeSection.h"

#import "Line.h"
#import "LineViewController.h"

@implementation LineTypesHomeSection

int LineMenuValues[] = {
    LINE_USAGE_URBAN,
    LINE_USAGE_SUBURBAN,
    LINE_USAGE_EXPRESS,
    LINE_USAGE_SPECIAL,
    LINE_USAGE_ALL,
    -1
};

-(LineTypesHomeSection*) init {
    self = [super init];
    self.menu = [NSArray arrayWithObjects:NSLocalizedString( @"Lignes urbaines", @""),
                          NSLocalizedString( @"Lignes suburbaines", @""),
                          NSLocalizedString( @"Lignes express", @""),
                          NSLocalizedString( @"Lignes spéciales", @""),
                          NSLocalizedString( @"Toutes les lignes", @""), /*@"Favorites",*/ nil ];
    return self;
}

-(NSString*) title {
    return @"Lignes";
}

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    if ( LineMenuValues[row] > 0 ) {
        LineViewController* lineViewController = [[LineViewController alloc] init];
        lineViewController.usageType = LineMenuValues[row];
        [controller.navigationController pushViewController:lineViewController animated:YES];
        [lineViewController release];
    }
}

@end
