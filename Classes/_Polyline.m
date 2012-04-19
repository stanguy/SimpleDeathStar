// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Polyline.m instead.

#import "_Polyline.h"

@implementation PolylineID
@end

@implementation _Polyline

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Polyline" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Polyline";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Polyline" inManagedObjectContext:moc_];
}

- (PolylineID*)objectID {
	return (PolylineID*)[super objectID];
}




@dynamic path;






@dynamic line;

	





@end
