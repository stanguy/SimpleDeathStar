//
//  ADViewComposer.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/08/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/ADBannerView.h>

@interface ADViewComposer : NSObject <ADBannerViewDelegate> {
    UIView* composedView;
    BOOL displayed;
}

- (ADViewComposer*) initWithView:(UIView*)otherView;
- (void)toDisappear;
- (void)changeDisplay:(BOOL)animated;
- (void)changeDisplay:(BOOL)show andAnimate:(BOOL)animated;

+ (id)BuildAdView:(UIView*)baseView;
+ (void)EnableAds:(BOOL)flag;

@end
