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
@synthesize title,subtitle,stop=stop;

-(void)dealloc{
    [stop release];
    [super dealloc];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate identifier:(NSString *)identifier {
    self = [super initWithCoordinate:coordinate identifier:identifier];
    return self;
}

- (id)initWithStop:(Stop*)pstop {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [pstop.lat doubleValue];
    coordinate.longitude = [pstop.lon doubleValue];
    self = [super initWithCoordinate:coordinate identifier:pstop.slug];
    self.stop = pstop;
    return self;
}

-(NSString*)title {
    return self.stop.name;
}

- (Stop*)stop {
    if( nil == stop ) {
        stop = [[Stop findFirstBySlug:self.identifier] retain];
    }
    return stop;
}

-(NSString*)subtitle {
    return [NSString stringWithFormat:NSLocalizedString( @"%@ ligne%@", @"" ), stop.line_count, [stop.line_count intValue] > 1 ? @"s" : @""];
}

@end
