// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Favorite.m instead.

#import "_Favorite.h"

@implementation FavoriteID
@end

@implementation _Favorite

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"favorites" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"favorites";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"favorites" inManagedObjectContext:moc_];
}

- (FavoriteID*)objectID {
	return (FavoriteID*)[super objectID];
}




@dynamic line_short_name;






@dynamic stop_name;










@end
