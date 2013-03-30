// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Line.m instead.

#import "_Line.h"

const struct LineAttributes LineAttributes = {
	.accessible = @"accessible",
	.bgcolor = @"bgcolor",
	.fgcolor = @"fgcolor",
	.forced_id = @"forced_id",
	.has_picto = @"has_picto",
	.is_hidden = @"is_hidden",
	.long_name = @"long_name",
	.old_src_id = @"old_src_id",
	.short_name = @"short_name",
	.src_id = @"src_id",
	.usage = @"usage",
};

const struct LineRelationships LineRelationships = {
	.headsigns = @"headsigns",
	.polylines = @"polylines",
	.stop_times = @"stop_times",
	.stops = @"stops",
};

const struct LineFetchedProperties LineFetchedProperties = {
};

@implementation LineID
@end

@implementation _Line

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Line";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Line" inManagedObjectContext:moc_];
}

- (LineID*)objectID {
	return (LineID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"accessibleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"accessible"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"forced_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"forced_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"has_pictoValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"has_picto"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_hidden"];
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





@dynamic bgcolor;






@dynamic fgcolor;






@dynamic forced_id;



- (int16_t)forced_idValue {
	NSNumber *result = [self forced_id];
	return [result shortValue];
}

- (void)setForced_idValue:(int16_t)value_ {
	[self setForced_id:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveForced_idValue {
	NSNumber *result = [self primitiveForced_id];
	return [result shortValue];
}

- (void)setPrimitiveForced_idValue:(int16_t)value_ {
	[self setPrimitiveForced_id:[NSNumber numberWithShort:value_]];
}





@dynamic has_picto;



- (BOOL)has_pictoValue {
	NSNumber *result = [self has_picto];
	return [result boolValue];
}

- (void)setHas_pictoValue:(BOOL)value_ {
	[self setHas_picto:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHas_pictoValue {
	NSNumber *result = [self primitiveHas_picto];
	return [result boolValue];
}

- (void)setPrimitiveHas_pictoValue:(BOOL)value_ {
	[self setPrimitiveHas_picto:[NSNumber numberWithBool:value_]];
}





@dynamic is_hidden;



- (BOOL)is_hiddenValue {
	NSNumber *result = [self is_hidden];
	return [result boolValue];
}

- (void)setIs_hiddenValue:(BOOL)value_ {
	[self setIs_hidden:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_hiddenValue {
	NSNumber *result = [self primitiveIs_hidden];
	return [result boolValue];
}

- (void)setPrimitiveIs_hiddenValue:(BOOL)value_ {
	[self setPrimitiveIs_hidden:[NSNumber numberWithBool:value_]];
}





@dynamic long_name;






@dynamic old_src_id;






@dynamic short_name;






@dynamic src_id;






@dynamic usage;






@dynamic headsigns;

	
- (NSMutableSet*)headsignsSet {
	[self willAccessValueForKey:@"headsigns"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"headsigns"];
  
	[self didAccessValueForKey:@"headsigns"];
	return result;
}
	

@dynamic polylines;

	
- (NSMutableSet*)polylinesSet {
	[self willAccessValueForKey:@"polylines"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"polylines"];
  
	[self didAccessValueForKey:@"polylines"];
	return result;
}
	

@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stop_times"];
  
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	

@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stops"];
  
	[self didAccessValueForKey:@"stops"];
	return result;
}
	






@end
