// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.m instead.

#import "_Stop.h"

const struct StopAttributes StopAttributes = {
	.accessible = @"accessible",
	.bike_count = @"bike_count",
	.lat = @"lat",
	.line_count = @"line_count",
	.lon = @"lon",
	.metro_count = @"metro_count",
	.name = @"name",
	.old_src_id = @"old_src_id",
	.pos_count = @"pos_count",
	.slug = @"slug",
	.src_id = @"src_id",
};

const struct StopRelationships StopRelationships = {
	.city = @"city",
	.close_pois = @"close_pois",
	.lines = @"lines",
	.stop_aliases = @"stop_aliases",
	.stop_times = @"stop_times",
};

const struct StopFetchedProperties StopFetchedProperties = {
};

@implementation StopID
@end

@implementation _Stop

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Stop" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Stop";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Stop" inManagedObjectContext:moc_];
}

- (StopID*)objectID {
	return (StopID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"accessibleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"accessible"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"bike_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bike_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"line_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"line_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"metro_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"metro_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pos_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pos_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic accessible;



- (BOOL)accessibleValue {
	NSNumber *result = [self accessible];
	return [result boolValue];
}

- (void)setAccessibleValue:(BOOL)value_ {
	[self setAccessible:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAccessibleValue {
	NSNumber *result = [self primitiveAccessible];
	return [result boolValue];
}

- (void)setPrimitiveAccessibleValue:(BOOL)value_ {
	[self setPrimitiveAccessible:[NSNumber numberWithBool:value_]];
}





@dynamic bike_count;



- (int16_t)bike_countValue {
	NSNumber *result = [self bike_count];
	return [result shortValue];
}

- (void)setBike_countValue:(int16_t)value_ {
	[self setBike_count:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBike_countValue {
	NSNumber *result = [self primitiveBike_count];
	return [result shortValue];
}

- (void)setPrimitiveBike_countValue:(int16_t)value_ {
	[self setPrimitiveBike_count:[NSNumber numberWithShort:value_]];
}





@dynamic lat;






@dynamic line_count;



- (int16_t)line_countValue {
	NSNumber *result = [self line_count];
	return [result shortValue];
}

- (void)setLine_countValue:(int16_t)value_ {
	[self setLine_count:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLine_countValue {
	NSNumber *result = [self primitiveLine_count];
	return [result shortValue];
}

- (void)setPrimitiveLine_countValue:(int16_t)value_ {
	[self setPrimitiveLine_count:[NSNumber numberWithShort:value_]];
}





@dynamic lon;






@dynamic metro_count;



- (int16_t)metro_countValue {
	NSNumber *result = [self metro_count];
	return [result shortValue];
}

- (void)setMetro_countValue:(int16_t)value_ {
	[self setMetro_count:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMetro_countValue {
	NSNumber *result = [self primitiveMetro_count];
	return [result shortValue];
}

- (void)setPrimitiveMetro_countValue:(int16_t)value_ {
	[self setPrimitiveMetro_count:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic old_src_id;






@dynamic pos_count;



- (int16_t)pos_countValue {
	NSNumber *result = [self pos_count];
	return [result shortValue];
}

- (void)setPos_countValue:(int16_t)value_ {
	[self setPos_count:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePos_countValue {
	NSNumber *result = [self primitivePos_count];
	return [result shortValue];
}

- (void)setPrimitivePos_countValue:(int16_t)value_ {
	[self setPrimitivePos_count:[NSNumber numberWithShort:value_]];
}





@dynamic slug;






@dynamic src_id;






@dynamic city;

	

@dynamic close_pois;

	
- (NSMutableSet*)close_poisSet {
	[self willAccessValueForKey:@"close_pois"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"close_pois"];
  
	[self didAccessValueForKey:@"close_pois"];
	return result;
}
	

@dynamic lines;

	
- (NSMutableSet*)linesSet {
	[self willAccessValueForKey:@"lines"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"lines"];
  
	[self didAccessValueForKey:@"lines"];
	return result;
}
	

@dynamic stop_aliases;

	
- (NSMutableSet*)stop_aliasesSet {
	[self willAccessValueForKey:@"stop_aliases"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stop_aliases"];
  
	[self didAccessValueForKey:@"stop_aliases"];
	return result;
}
	

@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stop_times"];
  
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	






@end
