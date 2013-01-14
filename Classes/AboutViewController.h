//
//  AboutViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/28/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADViewComposer;

enum AboutType {
    ABOUT_ABOUT,
    ABOUT_PANIC,
    ABOUT_ONLINE,
    ABOUT_TWITS,
    ABOUT_MSBM
};

@interface AboutViewController : UIViewController <UIWebViewDelegate> {
@private
    IBOutlet UIWebView* webView;
    int type_;
    ADViewComposer* viewComposer_;
}

@property (nonatomic) int type;
@end
