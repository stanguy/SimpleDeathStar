// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GTFSCalendarDate.m instead.

#import "_GTFSCalendarDate.h"

const struct GTFSCalendarDateAttributes GTFSCalendarDateAttributes = {
	.exception_date = @"exception_date",
	.is_exclusion = @"is_exclusion",
};

const struct GTFSCalendarDateRelationships GTFSCalendarDateRelationships = {
	.calendar = @"calendar",
};

const struct GTFSCalendarDateFetchedProperties GTFSCalendarDateFetchedProperties = {
};

@implementation GTFSCalendarDateID
@end

@implementation _GTFSCalendarDate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CalendarDate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CalendarDate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CalendarDate" inManagedObjectContext:moc_];
}

- (GTFSCalendarDateID*)objectID {
	return (GTFSCalendarDateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"is_exclusionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_exclusion"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic exception_date;






@dynamic is_exclusion;



- (BOOL)is_exclusionValue {
	NSNumber *result = [self is_exclusion];
	return [result boolValue];
}

- (void)setIs_exclusionValue:(BOOL)value_ {
	[self setIs_exclusion:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_exclusionValue {
	NSNumber *result = [self primitiveIs_exclusion];
	return [result boolValue];
}

- (void)setPrimitiveIs_exclusionValue:(BOOL)value_ {
	[self setPrimitiveIs_exclusion:[NSNumber numberWithBool:value_]];
}





@dynamic calendar;

	






@end
