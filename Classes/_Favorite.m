// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Favorite.m instead.

#import "_Favorite.h"

@implementation FavoriteID
@end

@implementation _Favorite

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"favorites" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"favorites";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"favorites" inManagedObjectContext:moc_];
}

- (FavoriteID*)objectID {
	return (FavoriteID*)[super objectID];
}




@dynamic stop_id;






@dynamic created_at;






@dynamic line_id;






@dynamic stop_name;






@dynamic line_short_name;






@dynamic view_count;



- (int)view_countValue {
	NSNumber *result = [self view_count];
	return [result intValue];
}

- (void)setView_countValue:(int)value_ {
	[self setView_count:[NSNumber numberWithInt:value_]];
}

- (int)primitiveView_countValue {
	NSNumber *result = [self primitiveView_count];
	return [result intValue];
}

- (void)setPrimitiveView_countValue:(int)value_ {
	[self setPrimitiveView_count:[NSNumber numberWithInt:value_]];
}









@end
