// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Line.m instead.

#import "_Line.h"

@implementation LineID
@end

@implementation _Line

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Line";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Line" inManagedObjectContext:moc_];
}

- (LineID*)objectID {
	return (LineID*)[super objectID];
}




@dynamic fgcolor;






@dynamic usage;






@dynamic bgcolor;






@dynamic short_name;






@dynamic long_name;






@dynamic stops;

	
- (NSMutableSet*)stopsSet {
	[self willAccessValueForKey:@"stops"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stops"];
	[self didAccessValueForKey:@"stops"];
	return result;
}
	

@dynamic stop_times;

	
- (NSMutableSet*)stop_timesSet {
	[self willAccessValueForKey:@"stop_times"];
	NSMutableSet *result = [self mutableSetValueForKey:@"stop_times"];
	[self didAccessValueForKey:@"stop_times"];
	return result;
}
	

@dynamic headsigns;

	
- (NSMutableSet*)headsignsSet {
	[self willAccessValueForKey:@"headsigns"];
	NSMutableSet *result = [self mutableSetValueForKey:@"headsigns"];
	[self didAccessValueForKey:@"headsigns"];
	return result;
}
	





@end
