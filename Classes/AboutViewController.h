//
//  AboutViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/28/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>


enum AboutType {
    ABOUT_ABOUT,
    ABOUT_PANIC
};

@interface AboutViewController : UIViewController {
@private
    IBOutlet UIWebView* webView;
    int type_;
}

@property (nonatomic) int type;
@end
