// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopAlias.m instead.

#import "_StopAlias.h"

const struct StopAliasAttributes StopAliasAttributes = {
	.old_src_id = @"old_src_id",
	.src_code = @"src_code",
	.src_id = @"src_id",
};

const struct StopAliasRelationships StopAliasRelationships = {
	.stop = @"stop",
};

const struct StopAliasFetchedProperties StopAliasFetchedProperties = {
};

@implementation StopAliasID
@end

@implementation _StopAlias

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"StopAlias" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"StopAlias";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"StopAlias" inManagedObjectContext:moc_];
}

- (StopAliasID*)objectID {
	return (StopAliasID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic old_src_id;






@dynamic src_code;






@dynamic src_id;






@dynamic stop;

	






@end
