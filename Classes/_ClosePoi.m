// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClosePoi.m instead.

#import "_ClosePoi.h"

@implementation ClosePoiID
@end

@implementation _ClosePoi

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ClosePoi" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ClosePoi";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ClosePoi" inManagedObjectContext:moc_];
}

- (ClosePoiID*)objectID {
	return (ClosePoiID*)[super objectID];
}




@dynamic distance;



- (short)distanceValue {
	NSNumber *result = [self distance];
	return [result shortValue];
}

- (void)setDistanceValue:(short)value_ {
	[self setDistance:[NSNumber numberWithShort:value_]];
}

- (short)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result shortValue];
}

- (void)setPrimitiveDistanceValue:(short)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithShort:value_]];
}





@dynamic poi;

	





@end
