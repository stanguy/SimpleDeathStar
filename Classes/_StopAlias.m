// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopAlias.m instead.

#import "_StopAlias.h"

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




@dynamic src_code;






@dynamic src_id;






@dynamic old_src_id;






@dynamic stop;

	





@end
