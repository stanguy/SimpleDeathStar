#import "_StopTime.h"


#define BASE_TIMESHIFT 60*60*2

@class Favorite;


enum  {
    STOPTIME_PREFERENCE = 0,
    STOPTIME_DEPARTURE = 1,
    STOPTIME_ARRIVAL
} ;

@interface StopTime : _StopTime {}
// Custom logic goes here.

+ (NSFetchedResultsController*) findByLine:(Line*) line andStop:(Stop*) stop atDate:(NSDate*) date;
+ (NSFetchedResultsController*) findFollowing:(StopTime*)stopTime;
+ (NSArray*) findComingAt:(Favorite*)favorite;
+ (NSArray*) findComingAtStop:(Stop*)stop andLine:(Line*)line;

- (NSString*) formatTime;
- (NSString*) formatTime:(int)time_e;
- (NSString*) formatTime:(int)time_e asRelative:(BOOL)isRelative;

@end
