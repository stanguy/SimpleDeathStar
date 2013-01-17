//
//  PoiViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 01/27/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableWithAdViewController.h"

@class Stop;

@interface PoiViewController : TableWithAdViewController {
    
    @private
    Stop* stop_;
}
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) NSDictionary* pois;

@end
