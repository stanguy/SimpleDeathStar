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

@interface  HelpHomeSection () {
    int type_;
}

@end

@implementation HelpHomeSection

int AboutMenuValues[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    ABOUT_SUPPORT,
    ABOUT_ONLINE,
#ifndef VERSION_STLO
    ABOUT_TWITS,
    ABOUT_MSBM,
#endif
    -1
};

int AboutMenuValuesLocal[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    -1
};
int AboutMenuValuesRemote[] = {
    ABOUT_SUPPORT,
    ABOUT_ONLINE,
#ifndef VERSION_STLO
    ABOUT_TWITS,
    ABOUT_MSBM,
#endif
    -1
};

@synthesize title;


-(id) init {
    self = [super init];
    self.menu =
        [NSArray
         arrayWithObjects: NSLocalizedString( @"À propos", @"" ),
                           NSLocalizedString( @"Pas de panique", @"" ),
                           NSLocalizedString( @"Support", @"" ),
                           NSLocalizedString( @"En ligne", @"" ),
#ifndef VERSION_STLO
                           @"@starbusmetro",
                           @"m.starbusmetro.fr",
#endif
                            nil ];
    type_ = kHelpFull;
    return self;
}

-(id)initWithType:(HelpType)type{
    self = [super init];
    type_ = type;
    switch ( type ) {
        case kHelpLocal:
            self.menu = [NSArray arrayWithObjects:NSLocalizedString( @"À propos", @"" ),
                         NSLocalizedString( @"Pas de panique", @"" ), nil];
            self.title = NSLocalizedString( @"Ici", @"" );
            break;
        case kHelpRemote:
            self.menu = [NSArray arrayWithObjects:NSLocalizedString( @"Support", @"" ),
                         NSLocalizedString( @"En ligne", @"" ),
#ifndef VERSION_STLO
                         @"@starbusmetro", @"m.starbusmetro.fr",
#endif
                         nil ];
            self.title = NSLocalizedString( @"Et ailleurs", @"" );
            break;
        default:
            break;
    }
    return self;
}


-(void)selectRow:(NSInteger)row from:(UIViewController*)controller{
    UIViewController* nextController;
    nextController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    int menu_type=0;
    switch ( type_ ) {
        case kHelpFull:
            menu_type = AboutMenuValues[row];
            break;
        case kHelpLocal:
            menu_type = AboutMenuValuesLocal[row];
            break;
        case kHelpRemote:
            menu_type = AboutMenuValuesRemote[row];
            break;
        default:
            break;
    }
    ((AboutViewController*)nextController).type = menu_type;
    [controller.navigationController pushViewController:nextController animated:YES];
    [nextController release];
}

@end
