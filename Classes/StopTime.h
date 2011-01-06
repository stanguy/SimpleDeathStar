#import "_StopTime.h"


#define BASE_TIMESHIFT 60*60*2

@interface StopTime : _StopTime {}
// Custom logic goes here.

+ (NSFetchedResultsController*) findByLine:(Line*) line andStop:(Stop*) stop atDate:(NSDate*) date;
+ (NSFetchedResultsController*) findFollowing:(StopTime*)stopTime;
@end
