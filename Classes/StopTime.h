#import "_StopTime.h"
#import "TimePoint.h"


#define BASE_TIMESHIFT 60*60*2

@class Favorite;

@interface StopTime : _StopTime <TimePoint> {}
// Custom logic goes here.

+ (NSFetchedResultsController*) findByLine:(Line*) line andStop:(Stop*) stop atDate:(NSDate*) date;
+ (NSFetchedResultsController*) findFollowing:(StopTime*)stopTime;
+ (NSArray*) findComingAt:(Favorite*)favorite;
+ (NSArray*) findComingAtStop:(Stop*)stop andLine:(Line*)line;

-(NSString*)departure:(NSDate *)relative_date;
-(NSString*)arrival:(NSDate *)relative_date;

@end
