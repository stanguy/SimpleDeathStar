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

@synthesize mapView = mapView_, mapController = mapController_; 


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
    NSLog( @"using annotation %@ identified by %@", marker, marker.identifier );
    if (!view)
    {
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
    return annotation;
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
/*    self.mapView.showsUserLocation = YES;
    [self.mapView setShowsUserLocation:YES];*/
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
