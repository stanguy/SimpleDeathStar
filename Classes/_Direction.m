// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Direction.m instead.

#import "_Direction.h"

@implementation DirectionID
@end

@implementation _Direction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Direction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Direction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Direction" inManagedObjectContext:moc_];
}

- (DirectionID*)objectID {
	return (DirectionID*)[super objectID];
}




@dynamic headsign;






@dynamic line;

	

@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stop_times"];
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	





@end
