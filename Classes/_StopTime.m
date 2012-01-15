// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopTime.m instead.

#import "_StopTime.h"

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




@dynamic arrival;



- (int)arrivalValue {
	NSNumber *result = [self arrival];
	return [result intValue];
}

- (void)setArrivalValue:(int)value_ {
	[self setArrival:[NSNumber numberWithInt:value_]];
}

- (int)primitiveArrivalValue {
	NSNumber *result = [self primitiveArrival];
	return [result intValue];
}

- (void)setPrimitiveArrivalValue:(int)value_ {
	[self setPrimitiveArrival:[NSNumber numberWithInt:value_]];
}





@dynamic stop_sequence;



- (short)stop_sequenceValue {
	NSNumber *result = [self stop_sequence];
	return [result shortValue];
}

- (void)setStop_sequenceValue:(short)value_ {
	[self setStop_sequence:[NSNumber numberWithShort:value_]];
}

- (short)primitiveStop_sequenceValue {
	NSNumber *result = [self primitiveStop_sequence];
	return [result shortValue];
}

- (void)setPrimitiveStop_sequenceValue:(short)value_ {
	[self setPrimitiveStop_sequence:[NSNumber numberWithShort:value_]];
}





@dynamic trip_id;



- (int)trip_idValue {
	NSNumber *result = [self trip_id];
	return [result intValue];
}

- (void)setTrip_idValue:(int)value_ {
	[self setTrip_id:[NSNumber numberWithInt:value_]];
}

- (int)primitiveTrip_idValue {
	NSNumber *result = [self primitiveTrip_id];
	return [result intValue];
}

- (void)setPrimitiveTrip_idValue:(int)value_ {
	[self setPrimitiveTrip_id:[NSNumber numberWithInt:value_]];
}





@dynamic calendar;



- (short)calendarValue {
	NSNumber *result = [self calendar];
	return [result shortValue];
}

- (void)setCalendarValue:(short)value_ {
	[self setCalendar:[NSNumber numberWithShort:value_]];
}

- (short)primitiveCalendarValue {
	NSNumber *result = [self primitiveCalendar];
	return [result shortValue];
}

- (void)setPrimitiveCalendarValue:(short)value_ {
	[self setPrimitiveCalendar:[NSNumber numberWithShort:value_]];
}





@dynamic trip_bearing;






@dynamic departure;



- (int)departureValue {
	NSNumber *result = [self departure];
	return [result intValue];
}

- (void)setDepartureValue:(int)value_ {
	[self setDeparture:[NSNumber numberWithInt:value_]];
}

- (int)primitiveDepartureValue {
	NSNumber *result = [self primitiveDeparture];
	return [result intValue];
}

- (void)setPrimitiveDepartureValue:(int)value_ {
	[self setPrimitiveDeparture:[NSNumber numberWithInt:value_]];
}





@dynamic line;

	

@dynamic direction;

	

@dynamic stop;

	





@end
