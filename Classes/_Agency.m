// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Agency.m instead.

#import "_Agency.h"

const struct AgencyAttributes AgencyAttributes = {
	.ads_allowed = @"ads_allowed",
	.city = @"city",
	.feed_ref = @"feed_ref",
	.feed_url = @"feed_url",
};

const struct AgencyRelationships AgencyRelationships = {
};

const struct AgencyFetchedProperties AgencyFetchedProperties = {
};

@implementation AgencyID
@end

@implementation _Agency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Agency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Agency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Agency" inManagedObjectContext:moc_];
}

- (AgencyID*)objectID {
	return (AgencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"ads_allowedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ads_allowed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic ads_allowed;



- (BOOL)ads_allowedValue {
	NSNumber *result = [self ads_allowed];
	return [result boolValue];
}

- (void)setAds_allowedValue:(BOOL)value_ {
	[self setAds_allowed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAds_allowedValue {
	NSNumber *result = [self primitiveAds_allowed];
	return [result boolValue];
}

- (void)setPrimitiveAds_allowedValue:(BOOL)value_ {
	[self setPrimitiveAds_allowed:[NSNumber numberWithBool:value_]];
}





@dynamic city;






@dynamic feed_ref;






@dynamic feed_url;











@end
