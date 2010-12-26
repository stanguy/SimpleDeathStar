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




@dynamic lat;






@dynamic name;






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
