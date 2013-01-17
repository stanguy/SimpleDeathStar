//
//  KeolisRennesAPI.m
//  StarWS
//
//  Created by Sebastien Tanguy on 1/13/13.
//  Copyright (c) 2013 Sebastien Tanguy. All rights reserved.
//

#import "KeolisRennesAPI.h"

#import "APIStopTime.h"
#import "Line.h"
#import "Stop.h"
#import "StopAlias.h"
#import "NSObject+ToQuery.h"

@interface KeolisRennesAPI ()

-(id)callRemoteMethod:(NSString*)method with:(NSDictionary*)params;

@end

@implementation KeolisRennesAPI

-(id)callRemoteMethod:(NSString*)method with:(NSDictionary*)params{
    NSString* base_url = @"http://data.keolis-rennes.com/json/";
    NSMutableDictionary* query_params = [NSMutableDictionary dictionaryWithObjectsAndKeys:method, @"cmd", self.key, @"key", @"2.1", @"version", params, @"param", nil];
    NSString* full_url = [NSString stringWithFormat:@"%@?%@", base_url, [query_params to_query]];
    NSLog( @"full url: %@", full_url );
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:full_url]];
    NSError* error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //    NSLog( @"%@", json);
    if ( nil != error ) {
        return nil;
    }
    return json;
}

- (NSArray*) findNextDepartureAtStop:(Stop*)stop{
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:@"stop" forKey:@"mode"];
    NSMutableArray* stops = [NSMutableArray arrayWithCapacity:[[stop stop_aliases] count]];
    for ( StopAlias* alias in [stop stop_aliases]) {
        [stops addObject:alias.src_code];
    }
    //    NSLog( @"%@", data );
    
    NSDateFormatter *frm = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"en_US_POSIX"];
    [frm setLocale:locale];
    //    [locale release];
    [frm setDateStyle:NSDateFormatterLongStyle];
    [frm setFormatterBehavior:NSDateFormatterBehavior10_4];
    [frm setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSMutableArray* stoptimes = [NSMutableArray array];
    NSArray* stoplines_a;
    
    const int nbStopsPerCall = 5;
    while ( [stops count] > 0 ) {
        NSRange range;
        range.location = 0;
        range.length = [stops count] > nbStopsPerCall ? nbStopsPerCall : [stops count];
        NSArray* current_stops = [stops subarrayWithRange:range];
        [stops removeObjectsInRange:range];
        
        [params setObject:current_stops forKey:@"stop"];
        id answer = [self callRemoteMethod:@"getbusnextdepartures" with:params];
        id data = [[[answer objectForKey:@"opendata"] objectForKey:@"answer"] objectForKey:@"data"];
        NSString* remote_time = [[data objectForKey:@"@attributes"] objectForKey:@"localdatetime"];
        NSLog( @"%@", remote_time );
        
        id stoplines = [data objectForKey:@"stopline"];
        if ( nil != stoplines ) {
            if( [stoplines isKindOfClass:[NSArray class]]) {
                stoplines_a = stoplines;
            } else {
                stoplines_a = [NSArray arrayWithObject:stoplines];
            }
            for ( id stopline in stoplines_a) {
                NSLog( @"%@", [stopline objectForKey:@"stop"] );
                Line* line = [Line findFirstBySrcId:[stopline objectForKey:@"route"] inContext:stop.managedObjectContext];
                if ( nil == line ) {
                    NSLog( @"Unable to find route %@", [stopline objectForKey:@"route"]);
                    continue;
                }
                id departures = [[stopline objectForKey:@"departures"] objectForKey:@"departure"];
                NSArray* departures_a;
                if ( [departures isKindOfClass:[NSArray class]]) {
                    departures_a = departures;
                } else {
                    departures_a = [NSArray arrayWithObject:departures];
                }
                for ( id departure in departures_a ) {
                    APIStopTime* stoptime = [[APIStopTime alloc] init];
                    stoptime.direction = [[departure objectForKey:@"@attributes"] objectForKey:@"headsign"];
                    stoptime.accurate = 1 == [[[departure objectForKey:@"@attributes"] objectForKey:@"accurate"] integerValue];
                    stoptime.stop = stop;
                    stoptime.line = line;
                    stoptime.date = [frm dateFromString:[departure objectForKey:@"content"]];
                    [stoptimes addObject:stoptime];
                }
            }
        }
        NSLog( @"stoptimes currently: %u", [stoptimes count] );
    }
    //    NSLog( @"%@", stoptimes );
    return stoptimes;
}

@end
