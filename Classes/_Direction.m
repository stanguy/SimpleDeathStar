// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Direction.m instead.

#import "_Direction.h"

const struct DirectionAttributes DirectionAttributes = {
	.headsign = @"headsign",
};

const struct DirectionRelationships DirectionRelationships = {
	.line = @"line",
	.stop_times = @"stop_times",
};

const struct DirectionFetchedProperties DirectionFetchedProperties = {
};

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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic headsign;






@dynamic line;

	

@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"stop_times"];
  
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	






@end
