//
//  HelpHomeSection.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "HelpHomeSection.h"

#import "AboutViewController.h"
#import "TwitsViewController.h"

@implementation HelpHomeSection

int AboutMenuValues[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    ABOUT_ONLINE,
    ABOUT_TWITS,
    -1
};


-(id) init {
    self = [super init];
    self.menu =
        [NSArray
         arrayWithObjects: NSLocalizedString( @"À propos", @"" ),
                           NSLocalizedString( @"Pas de panique", @"" ),
                           NSLocalizedString( @"En ligne", @"" ),
                           @"@starbusmetro", nil ];
    return self;
}

-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    UIViewController* nextController;
    nextController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    ((AboutViewController*)nextController).type = AboutMenuValues[row];
    [controller.navigationController pushViewController:nextController animated:YES];
    [nextController release];
}

@end
