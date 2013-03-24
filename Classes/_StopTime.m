// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopTime.m instead.

#import "_StopTime.h"

const struct StopTimeAttributes StopTimeAttributes = {
	.arrival = @"arrival",
	.departure = @"departure",
	.stop_sequence = @"stop_sequence",
	.trip_bearing = @"trip_bearing",
	.trip_id = @"trip_id",
};

const struct StopTimeRelationships StopTimeRelationships = {
	.calendar = @"calendar",
	.direction = @"direction",
	.line = @"line",
	.stop = @"stop",
};

const struct StopTimeFetchedProperties StopTimeFetchedProperties = {
};

@implementation StopTimeID
@end

@implementation _StopTime

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"StopTime" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"StopTime";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"StopTime" inManagedObjectContext:moc_];
}

- (StopTimeID*)objectID {
	return (StopTimeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"arrivalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"arrival"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"departureValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"departure"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stop_sequenceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stop_sequence"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"trip_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"trip_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic arrival;



- (int32_t)arrivalValue {
	NSNumber *result = [self arrival];
	return [result intValue];
}

- (void)setArrivalValue:(int32_t)value_ {
	[self setArrival:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveArrivalValue {
	NSNumber *result = [self primitiveArrival];
	return [result intValue];
}

- (void)setPrimitiveArrivalValue:(int32_t)value_ {
	[self setPrimitiveArrival:[NSNumber numberWithInt:value_]];
}





@dynamic departure;



- (int32_t)departureValue {
	NSNumber *result = [self departure];
	return [result intValue];
}

- (void)setDepartureValue:(int32_t)value_ {
	[self setDeparture:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDepartureValue {
	NSNumber *result = [self primitiveDeparture];
	return [result intValue];
}

- (void)setPrimitiveDepartureValue:(int32_t)value_ {
	[self setPrimitiveDeparture:[NSNumber numberWithInt:value_]];
}





@dynamic stop_sequence;



- (int16_t)stop_sequenceValue {
	NSNumber *result = [self stop_sequence];
	return [result shortValue];
}

- (void)setStop_sequenceValue:(int16_t)value_ {
	[self setStop_sequence:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStop_sequenceValue {
	NSNumber *result = [self primitiveStop_sequence];
	return [result shortValue];
}

- (void)setPrimitiveStop_sequenceValue:(int16_t)value_ {
	[self setPrimitiveStop_sequence:[NSNumber numberWithShort:value_]];
}





@dynamic trip_bearing;






@dynamic trip_id;



- (int32_t)trip_idValue {
	NSNumber *result = [self trip_id];
	return [result intValue];
}

- (void)setTrip_idValue:(int32_t)value_ {
	[self setTrip_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTrip_idValue {
	NSNumber *result = [self primitiveTrip_id];
	return [result intValue];
}

- (void)setPrimitiveTrip_idValue:(int32_t)value_ {
	[self setPrimitiveTrip_id:[NSNumber numberWithInt:value_]];
}





@dynamic calendar;

	

@dynamic direction;

	

@dynamic line;

	

@dynamic stop;

	






@end
