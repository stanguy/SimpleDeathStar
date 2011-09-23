#import "_StopAlias.h"

@interface StopAlias : _StopAlias {}
// Custom logic goes here.

+ (StopAlias*)findBySrcId:(NSString*)src_id;
+ (StopAlias*)findByOldSrcId:(NSString*)old_src_id;

@end
