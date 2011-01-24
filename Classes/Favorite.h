#import "_Favorite.h"

@class Line;
@class Stop;

@interface Favorite : _Favorite {}
// Custom logic goes here.

+ (BOOL)existsWithLine:(Line*)line andStop:(Stop*) stop;
+ (void)addWithLine:(Line*)line andStop:(Stop*) stop;
+ (void)deleteWithLine:(Line*)line andStop:(Stop*) stop;
+ (int)count;
+ (NSArray*)topFavorites;
- (NSString*) title;
@end
