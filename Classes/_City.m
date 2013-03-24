// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to City.m instead.

#import "_City.h"

const struct CityAttributes CityAttributes = {
	.name = @"name",
	.stop_count = @"stop_count",
};

const struct CityRelationships CityRelationships = {
	.stops = @"stops",
};

const struct CityFetchedProperties CityFetchedProperties = {
};

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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"stop_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stop_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic stop_count;



- (int16_t)stop_countValue {
	NSNumber *result = [self stop_count];
	return [result shortValue];
}

- (void)setStop_countValue:(int16_t)value_ {
	[self setStop_count:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStop_countValue {
	NSNumber *result = [self primitiveStop_count];
	return [result shortValue];
}

- (void)setPrimitiveStop_countValue:(int16_t)value_ {
	[self setPrimitiveStop_count:[NSNumber numberWithShort:value_]];
}





@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stops"];
  
	[self didAccessValueForKey:@"stops"];
	return result;
}
	






@end
