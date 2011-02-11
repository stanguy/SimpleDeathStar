//
//  StopMapViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 02/03/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class XMMapController;

#import "MaptimizeKit.h"

@interface StopMapViewController : UIViewController <XMMapControllerDelegate> {
@private
    MKMapView *mapView_;
    XMMapController* maptimizeController_;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, readonly) XMMapController *mapController;

@end
