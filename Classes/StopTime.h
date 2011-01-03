#import "_StopTime.h"

@interface StopTime : _StopTime {}
// Custom logic goes here.

+ (NSFetchedResultsController*) findByLine:(Line*) line andStop:(Stop*) stop withTimeShift:(int) timeShift;
@end
