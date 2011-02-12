//
//  StopMapViewController.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 02/03/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "StopMapViewController.h"

#import "MaptimizeKit.h"

#import "StopAnnotation.h"
#import "StopTimeViewController.h"

#define MAP_KEY @"1c4548799006881c1748573593282eb8798be5d4"

@implementation StopMapViewController

@synthesize mapView = mapView_, mapController = mapController_,originalPosition = originalPosition_; 


#pragma mark -
#pragma mark Maptimize

- (XMMapController *)mapController
{
    if (! mapController_) {
        mapController_ = [[XMMapController alloc] init];
        mapController_.mapKey = MAP_KEY;
        mapController_.delegate = self;
        mapController_.distance = 50;
        mapController_.optimizeService.parser = self;
    }
    return mapController_;
}

- (void)mapController:(XMMapController *)mapController failedWithError:(NSError *)error
{
    NSLog( @"Error: %@", error); 
}

- (MKAnnotationView *)mapController:(XMMapController *)mapController viewForMarker:(XMMarker *)marker
{
    static NSString *identifier = @"PinMarkerWithStopAnnotation";
    
    MKPinAnnotationView *view = (MKPinAnnotationView*) [mapController.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[[MKPinAnnotationView alloc] initWithAnnotation:marker reuseIdentifier:identifier] autorelease];
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    [view setAnnotation:marker];
    view.pinColor = MKPinAnnotationColorGreen;
    
    return view;
}

- (XMMarker *)optimizeService:(XMOptimizeService *)optimizeService
         markerWithCoordinate:(CLLocationCoordinate2D)coordinate
                   identifier:(NSString *)identifier
                         data:(NSMutableDictionary *)data{
    StopAnnotation* annotation = [[StopAnnotation alloc] initWithCoordinate:coordinate identifier:identifier];
    return [annotation autorelease];
}

- (void)mapController:(XMMapController *)mapController annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    StopAnnotation* annotation = view.annotation;
    Stop* stop = annotation.stop;
    StopTimeViewController* stoptimeView = [[StopTimeViewController alloc] initWithNibName:@"StopTimeViewController" bundle:nil];
    stoptimeView.stop = stop;
    [self.navigationController pushViewController:stoptimeView animated:YES];
    [stoptimeView release];
}

#pragma mark -
#pragma mark init


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapController.mapView = self.mapView;
    MKCoordinateRegion region; 
    if ( originalPosition_ == nil ) {
        CLLocationCoordinate2D centerCoord = { 48.11, -1.68 };
        //    [self.mapView setCenterCoordinate:centerCoord];
        region.center.latitude = centerCoord.latitude; 
        region.center.longitude = centerCoord.longitude; 
        region.span.latitudeDelta = 0.4; 
        region.span.longitudeDelta = 0.4;
    } else {
        region.center.latitude = originalPosition_.coordinate.latitude; 
        region.center.longitude = originalPosition_.coordinate.longitude; 
        region.span.latitudeDelta = 0.04; 
        region.span.longitudeDelta = 0.04;
    }
    self.mapView.region = region;
    self.mapView.showsUserLocation = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mapController update];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
    [super viewWillDisappear:animated];
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
    [mapController_ release];
    [super dealloc];
}


@end
