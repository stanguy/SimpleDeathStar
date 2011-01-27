// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Poi.m instead.

#import "_Poi.h"

@implementation PoiID
@end

@implementation _Poi

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Poi" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Poi";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Poi" inManagedObjectContext:moc_];
}

- (PoiID*)objectID {
	return (PoiID*)[super objectID];
}




@dynamic type;






@dynamic name;






@dynamic lat;



- (float)latValue {
	NSNumber *result = [self lat];
	return [result floatValue];
}

- (void)setLatValue:(float)value_ {
	[self setLat:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result floatValue];
}

- (void)setPrimitiveLatValue:(float)value_ {
	[self setPrimitiveLat:[NSNumber numberWithFloat:value_]];
}





@dynamic lon;



- (float)lonValue {
	NSNumber *result = [self lon];
	return [result floatValue];
}

- (void)setLonValue:(float)value_ {
	[self setLon:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLonValue {
	NSNumber *result = [self primitiveLon];
	return [result floatValue];
}

- (void)setPrimitiveLonValue:(float)value_ {
	[self setPrimitiveLon:[NSNumber numberWithFloat:value_]];
}





@dynamic address;










@end
