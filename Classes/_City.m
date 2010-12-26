// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to City.m instead.

#import "_City.h"

@implementation CityID
@end

@implementation _City

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"City";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"City" inManagedObjectContext:moc_];
}

- (CityID*)objectID {
	return (CityID*)[super objectID];
}




@dynamic name;






@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stops"];
	[self didAccessValueForKey:@"stops"];
	return result;
}
	





@end
