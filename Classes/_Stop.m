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




@dynamic name;






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





@dynamic lat;






@dynamic lon;






@dynamic city;

	

@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stop_times"];
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	

@dynamic lines;

	
- (NSMutableSet*)linesSet {
	[self willAccessValueForKey:@"lines"];
	NSMutableSet *result = [self mutableSetValueForKey:@"lines"];
	[self didAccessValueForKey:@"lines"];
	return result;
}
	





@end
