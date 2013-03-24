#import "_GTFSCalendarDate.h"

extern  NSString* GTFSCalendarDateExclusions,*GTFSCalendarDateInclusions;

@interface GTFSCalendarDate : _GTFSCalendarDate {}
// Custom logic goes here.

+(NSDictionary*)findExceptionsAt:(NSDate*)date;


@end
