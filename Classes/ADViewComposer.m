//
//  ADViewComposer.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/08/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "ADViewComposer.h"
#import "SimpleDeathStarAppDelegate.h"

@implementation ADViewComposer

- (id)initWithView:(UIView*)otherView
{
    self = [super init];
    if (self) {
        // Initialization code here.
        displayed = NO;
        composedView = otherView;
        ADBannerView* adview = [SimpleDeathStarAppDelegate adView];
        if ( adview.bannerLoaded ) {
            NSLog( @"init with loaded banner" );
            [self changeDisplay:YES];
        }
    }
    
    return self;
}

- (void)changeDisplay:(BOOL)show andAnimate:(BOOL)animated {
    NSLog( @"show: %d, display: %d", show, displayed );
    if ( show == displayed ) { return; }
    ADBannerView *adBanner = [SimpleDeathStarAppDelegate adView];
    if ( show && adBanner.delegate != self ) {
        NSLog( @"\t\tGetting the delegate" );
        adBanner.delegate = self;
        if( adBanner.superview != nil && adBanner.superview != composedView.superview ) {
            [adBanner removeFromSuperview];
        }
        [composedView.superview addSubview:adBanner];
    }
    if ( ! ( adBanner.bannerLoaded || displayed ) ) { return ; }
    if ( show && adBanner.superview == nil ) {
        [composedView.superview addSubview:adBanner];
    }
	
	CGFloat animationDuration = animated ? 0.3f : 0.0f;
    // by default content consumes the entire view area
    CGRect contentFrame = composedView.superview.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = adBanner.bounds.size.height;
    
    if ( ! displayed ) {
        CGRect adFrame = adBanner.bounds;
        adFrame.origin = bannerOrigin;
        adBanner.frame = adFrame;
    }
    
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    CGRect targetFrame ;
    if (adBanner.bannerLoaded && show ) {
        contentFrame.size.height -= bannerHeight;
        targetFrame = CGRectOffset( adBanner.frame, 0, -bannerHeight );
    } else if ( displayed ) {
        targetFrame = CGRectOffset( adBanner.frame, 0, bannerHeight );
    }
    NSLog( @"\tfirst Origin: %fx%f", adBanner.frame.origin.x, adBanner.frame.origin.y );
    NSLog( @"\tbannerOrigin: %fx%f", bannerOrigin.x, bannerOrigin.y );
    NSLog( @"\tsuperview: %@", composedView.superview );
    
    NSLog( @"\ttarget frame: %fx%f / %fx%f" , targetFrame.origin.x, targetFrame.origin.y, targetFrame.size.width, targetFrame.size.height );
    NSLog( @"\tad superview: %@", adBanner.superview );
    NSLog( @"\tdelegate: %@", adBanner.delegate );
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         composedView.frame = contentFrame;
                         [composedView layoutIfNeeded];
                         adBanner.frame = targetFrame;
                     }];
    displayed = show;
    if ( ! displayed ) {
        [adBanner removeFromSuperview];
    }
}

- (void)changeDisplay:(BOOL)animated {
    [self changeDisplay:YES andAnimate:animated];
}

-(void)toDisappear {
    [self changeDisplay:NO andAnimate:YES];
    ADBannerView *adBanner = [SimpleDeathStarAppDelegate adView];
    if ( adBanner.delegate == self ) {
        adBanner.delegate = nil;
        [adBanner removeFromSuperview];
    }
}

+ (id)BuildAdView:(UIView*)baseView{
    ADBannerView* ad = [[ADBannerView alloc] initWithFrame:CGRectZero];
    
	// Set the autoresizing mask so that the banner is pinned to the bottom
	ad.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
	// Since we support all orientations, support portrait and landscape content sizes.
	// If you only supported landscape or portrait, you could remove the other from this set
	ad.requiredContentSizeIdentifiers = 
    (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] : 
    [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32, nil];
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
    frame.origin = CGPointMake(CGRectGetMinX( baseView.frame ), CGRectGetMaxY(baseView.frame));
    // Now set the banner view's frame
	ad.frame = frame;
    return ad;
}

#pragma mark - Ad banner delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog( @"Loaded banner view" );
    [self changeDisplay:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog( @"Error on bannerview" );
    if ( displayed ) {
        [self changeDisplay:NO andAnimate:YES];
    }
}

@end
