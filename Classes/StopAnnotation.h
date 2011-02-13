//
//  StopAnnotation.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 02/08/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@class Stop;

@interface StopAnnotation : XMMarker {

    Stop* stop;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) NSString* subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate identifier:(NSString *)identifier;
- (id)initWithStop:(Stop*)stop;

@end
