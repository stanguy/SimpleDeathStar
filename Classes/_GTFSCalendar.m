// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GTFSCalendar.m instead.

#import "_GTFSCalendar.h"

const struct GTFSCalendarAttributes GTFSCalendarAttributes = {
	.days = @"days",
	.end_date = @"end_date",
	.start_date = @"start_date",
};

const struct GTFSCalendarRelationships GTFSCalendarRelationships = {
	.calendar_dates = @"calendar_dates",
	.stoptimes = @"stoptimes",
};

const struct GTFSCalendarFetchedProperties GTFSCalendarFetchedProperties = {
};

@implementation GTFSCalendarID
@end

@implementation _GTFSCalendar

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Calendar";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:moc_];
}

- (GTFSCalendarID*)objectID {
	return (GTFSCalendarID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"daysValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"days"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic days;



- (int16_t)daysValue {
	NSNumber *result = [self days];
	return [result shortValue];
}

- (void)setDaysValue:(int16_t)value_ {
	[self setDays:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDaysValue {
	NSNumber *result = [self primitiveDays];
	return [result shortValue];
}

- (void)setPrimitiveDaysValue:(int16_t)value_ {
	[self setPrimitiveDays:[NSNumber numberWithShort:value_]];
}





@dynamic end_date;






@dynamic start_date;






@dynamic calendar_dates;

	
- (NSMutableSet*)calendar_datesSet {
	[self willAccessValueForKey:@"calendar_dates"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"calendar_dates"];
  
	[self didAccessValueForKey:@"calendar_dates"];
	return result;
}
	

@dynamic stoptimes;

	
- (NSMutableSet*)stoptimesSet {
	[self willAccessValueForKey:@"stoptimes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stoptimes"];
  
	[self didAccessValueForKey:@"stoptimes"];
	return result;
}
	






@end
