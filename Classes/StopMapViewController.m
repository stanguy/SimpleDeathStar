//
//  StopMapViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 02/03/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "StopMapViewController.h"

#import "MaptimizeKit.h"

#define MAP_KEY @"1c4548799006881c1748573593282eb8798be5d4"

@implementation StopMapViewController

@synthesize mapView = mapView_, mapController = mapController_; 

- (XMMapController *)mapController
{
    if (! mapController_) {
        mapController_ = [[XMMapController alloc] init];
        mapController_.mapKey = MAP_KEY;
        mapController_.delegate = self;
    }
    return mapController_;
}


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
    self.mapController.mapView = self.mapView;
    CLLocationCoordinate2D centerCoord = {48.11, -1.68 };
    [self.mapView setCenterCoordinate:centerCoord];
    MKCoordinateRegion region; 
    region.center.latitude = centerCoord.latitude; 
    region.center.longitude = centerCoord.longitude; 
    region.span.latitudeDelta = 0.4; 
    region.span.longitudeDelta = 0.4;
    self.mapView.region = region;
    self.mapView.showsUserLocation = YES;
    [self.mapView setShowsUserLocation:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mapController update];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
