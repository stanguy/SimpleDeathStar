//
//  HomeScreenViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 12/26/10.
//  Copyright 2010 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AbstractHomeSection.h"
#import "TableWithAdViewController.h"

typedef enum  {
    kHomeStyleFull,
    kHomeStyleStart
} HomeStyle;


@interface HomeScreenViewController : TableWithAdViewController <HomePageDelegate> {

}

@property (retain) NSArray* sections;

- (void)reloadByTimer;
- (id)initWithHomeStyle:(HomeStyle)style;

@end
