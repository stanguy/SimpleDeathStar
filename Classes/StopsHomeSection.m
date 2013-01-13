//
//  StopsHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "StopsHomeSection.h"

#import "CityViewController.h"
#import "StopMapViewController.h"
#import "StopViewController.h"


@implementation StopsHomeSection

-(id) init {
    self = [super init];
    self.menu = [NSArray
                 arrayWithObjects:NSLocalizedString( @"Arrêts par ville", @"" ),
                 NSLocalizedString( @"Tous les arrêts", @"" ),
                 NSLocalizedString( @"Sur la carte", @""),
                 nil];
    return self;
}

-(NSString*)title {
    return @"Recherche par arrêt";
}

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    UIViewController* nextController = nil;
    switch ( row ) {
        case 0:
            nextController = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
            break;
        case 1:
            nextController = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
            break;
        case 2:
            nextController = [[StopMapViewController alloc] initWithNibName:@"StopMapViewController" bundle:nil];
            break;
    }
    if ( nil != nextController ) {
        [controller.navigationController pushViewController:nextController animated:YES];
        [nextController release];
    }
}

@end
