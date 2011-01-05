// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to City.m instead.

#import "_City.h"

@implementation CityID
@end

@implementation _City

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"City";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"City" inManagedObjectContext:moc_];
}

- (CityID*)objectID {
	return (CityID*)[super objectID];
}




@dynamic name;






@dynamic stop_count;



- (short)stop_countValue {
	NSNumber *result = [self stop_count];
	return [result shortValue];
}

- (void)setStop_countValue:(short)value_ {
	[self setStop_count:[NSNumber numberWithShort:value_]];
}

- (short)primitiveStop_countValue {
	NSNumber *result = [self primitiveStop_count];
	return [result shortValue];
}

- (void)setPrimitiveStop_countValue:(short)value_ {
	[self setPrimitiveStop_count:[NSNumber numberWithShort:value_]];
}





@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stops"];
	[self didAccessValueForKey:@"stops"];
	return result;
}
	





@end
