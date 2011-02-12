//
//  StopAnnotation.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 02/08/11.
//  Copyright 2011 dthg.net. All rights reserved.
//

#import "MaptimizeKit.h"

#import "StopAnnotation.h"

#import "Stop.h"

@implementation StopAnnotation
@synthesize title,stop=stop;

-(void)dealloc{
    [title release];
    [super dealloc];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate identifier:(NSString *)identifier {
    self = [super initWithCoordinate:coordinate identifier:identifier];
//    stop = [Stop findFirstBySlug:identifier];
//    title = stop.name ;//marker.identifier;
    return self;
}

-(NSString*)title {
    NSLog(@"StopAnnotation.title");
    return self.stop.name;
}

- (Stop*)stop {
    if( nil == stop ) {
        stop = [[Stop findFirstBySlug:self.identifier] retain];
    }
    return stop;
}

@end
