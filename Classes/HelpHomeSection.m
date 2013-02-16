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
    ABOUT_ONLINE,
    ABOUT_TWITS,
    ABOUT_MSBM,
    -1
};

int AboutMenuValuesLocal[] = {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    -1
};
int AboutMenuValuesRemote[] = {
    ABOUT_ONLINE,
    ABOUT_TWITS,
    ABOUT_MSBM,
    -1
};

@synthesize title;


-(id) init {
    self = [super init];
    self.menu =
        [NSArray
         arrayWithObjects: NSLocalizedString( @"À propos", @"" ),
                           NSLocalizedString( @"Pas de panique", @"" ),
                           NSLocalizedString( @"En ligne", @"" ),
                           @"@starbusmetro",
                           @"m.starbusmetro.fr",
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
            self.menu = [NSArray arrayWithObjects:NSLocalizedString( @"En ligne", @"" ),
                         @"@starbusmetro", @"m.starbusmetro.fr", nil ];
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
