// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClosePoi.m instead.

#import "_ClosePoi.h"

const struct ClosePoiAttributes ClosePoiAttributes = {
	.distance = @"distance",
};

const struct ClosePoiRelationships ClosePoiRelationships = {
	.poi = @"poi",
};

const struct ClosePoiFetchedProperties ClosePoiFetchedProperties = {
};

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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic distance;



- (int16_t)distanceValue {
	NSNumber *result = [self distance];
	return [result shortValue];
}

- (void)setDistanceValue:(int16_t)value_ {
	[self setDistance:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result shortValue];
}

- (void)setPrimitiveDistanceValue:(int16_t)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithShort:value_]];
}





@dynamic poi;

	






@end
