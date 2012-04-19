//
//  AboutViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/28/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import "AboutViewController.h"
#import "ADViewComposer.h"


@implementation AboutViewController

@synthesize type = type_;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* fileUrl = nil;
    NSArray* preferredLangs = [NSLocale preferredLanguages];
    NSString* currentLocale = nil;
    NSArray* knownLanguages = [NSArray arrayWithObjects:@"fr", @"en", nil];
    if ( [preferredLangs count] > 0 ) {
        if ( [knownLanguages containsObject:[preferredLangs objectAtIndex:0] ] ) {
            currentLocale = [preferredLangs objectAtIndex:0];
        }
    }
    if ( nil == currentLocale ) {
        //NSLog( @"defaulting to french" );
        currentLocale = [knownLanguages objectAtIndex:0];
    }
    //NSLog( @"%@", currentLocale );
#ifdef VERSION_STLO
    NSString* about_format = @"about_stlo_%@";
    NSString* online_url = @"http://maps.dthg.net/city/saint-lo";
#else
    NSString* about_format = @"about_%@";
    NSString* online_url = @"http://maps.dthg.net/city/rennes";
#endif
    switch ( self.type ) {
        case ABOUT_ABOUT:
            self.navigationItem.title = NSLocalizedString( @"À propos", @"" );
            fileUrl = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:about_format, currentLocale] ofType:@"html"]];
            break;
        case ABOUT_PANIC:
            self.navigationItem.title = NSLocalizedString( @"Pas de panique", @"" );
            fileUrl = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"panic_%@", currentLocale] ofType:@"html"]];
            break;
        case ABOUT_ONLINE:
            self.navigationItem.title = NSLocalizedString( @"En ligne", @"" );
            fileUrl = [NSURL URLWithString:online_url];
            break;
        default:
            return;
            break;
    }
    [webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
    viewComposer_ = [[ADViewComposer alloc] initWithView:webView];
}

-(void)webView:(UIWebView*)view didFailLoadWithError:(NSError*)error {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle: NSLocalizedString( @"Erreur", @"" )
                               message: NSLocalizedString( @"Impossible de charger la page.", @"" )
                              delegate: nil
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [viewComposer_ toDisappear];
}


- (void)dealloc {
    webView.delegate = nil;
    [webView stopLoading];
    [viewComposer_ release];
    [super dealloc];
}


@end
