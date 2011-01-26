#import "_Favorite.h"

@class Line;
@class Stop;

@interface Favorite : _Favorite {}
// Custom logic goes here.

+ (Favorite*)fetchWithLine:(Line*)line andStop:(Stop*) stop inContext:(NSManagedObjectContext*)context_;
+ (Favorite*)fetchWithLine:(Line*)line andStop:(Stop*) stop;
+ (BOOL)existsWithLine:(Line *)line andStop:(Stop *)stop andOhBTWIncCounter:(BOOL)incCounter;
+ (BOOL)existsWithLine:(Line*)line andStop:(Stop*) stop;
+ (void)addWithLine:(Line*)line andStop:(Stop*) stop;
+ (void)deleteWithLine:(Line*)line andStop:(Stop*) stop;
+ (int)count;
+(NSFetchedResultsController*) findAll;
+ (NSArray*)topFavorites;
- (NSString*) title;
@end
