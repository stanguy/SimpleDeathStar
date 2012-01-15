// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.m instead.

#import "_Stop.h"

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




@dynamic bike_count;



- (short)bike_countValue {
	NSNumber *result = [self bike_count];
	return [result shortValue];
}

- (void)setBike_countValue:(short)value_ {
	[self setBike_count:[NSNumber numberWithShort:value_]];
}

- (short)primitiveBike_countValue {
	NSNumber *result = [self primitiveBike_count];
	return [result shortValue];
}

- (void)setPrimitiveBike_countValue:(short)value_ {
	[self setPrimitiveBike_count:[NSNumber numberWithShort:value_]];
}





@dynamic src_id;






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





@dynamic metro_count;



- (short)metro_countValue {
	NSNumber *result = [self metro_count];
	return [result shortValue];
}

- (void)setMetro_countValue:(short)value_ {
	[self setMetro_count:[NSNumber numberWithShort:value_]];
}

- (short)primitiveMetro_countValue {
	NSNumber *result = [self primitiveMetro_count];
	return [result shortValue];
}

- (void)setPrimitiveMetro_countValue:(short)value_ {
	[self setPrimitiveMetro_count:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic lon;






@dynamic slug;






@dynamic lat;






@dynamic old_src_id;






@dynamic pos_count;



- (short)pos_countValue {
	NSNumber *result = [self pos_count];
	return [result shortValue];
}

- (void)setPos_countValue:(short)value_ {
	[self setPos_count:[NSNumber numberWithShort:value_]];
}

- (short)primitivePos_countValue {
	NSNumber *result = [self primitivePos_count];
	return [result shortValue];
}

- (void)setPrimitivePos_countValue:(short)value_ {
	[self setPrimitivePos_count:[NSNumber numberWithShort:value_]];
}





@dynamic line_count;



- (short)line_countValue {
	NSNumber *result = [self line_count];
	return [result shortValue];
}

- (void)setLine_countValue:(short)value_ {
	[self setLine_count:[NSNumber numberWithShort:value_]];
}

- (short)primitiveLine_countValue {
	NSNumber *result = [self primitiveLine_count];
	return [result shortValue];
}

- (void)setPrimitiveLine_countValue:(short)value_ {
	[self setPrimitiveLine_count:[NSNumber numberWithShort:value_]];
}





@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stop_times"];
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	

@dynamic close_pois;

	
- (NSMutableSet*)close_poisSet {
	[self willAccessValueForKey:@"close_pois"];
	NSMutableSet *result = [self mutableSetValueForKey:@"close_pois"];
	[self didAccessValueForKey:@"close_pois"];
	return result;
}
	

@dynamic city;

	

@dynamic lines;

	
- (NSMutableSet*)linesSet {
	[self willAccessValueForKey:@"lines"];
	NSMutableSet *result = [self mutableSetValueForKey:@"lines"];
	[self didAccessValueForKey:@"lines"];
	return result;
}
	

@dynamic stop_aliases;

	
- (NSMutableSet*)stop_aliasesSet {
	[self willAccessValueForKey:@"stop_aliases"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stop_aliases"];
	[self didAccessValueForKey:@"stop_aliases"];
	return result;
}
	





@end
