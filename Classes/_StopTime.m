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





@dynamic direction;

	

@dynamic line;

	

@dynamic stop;

	






+ (NSArray*)fetchStopTimeComing:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchStopTimeComing:moc_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchStopTimeComing:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	
	NSDictionary *substitutionVariables = [NSDictionary dictionary];
										
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"StopTimeComing"
													 substitutionVariables:substitutionVariables];
	NSAssert(fetchRequest, @"Can't find fetch request named \"StopTimeComing\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}


@end
