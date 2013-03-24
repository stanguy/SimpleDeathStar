// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopAlias.h instead.

#import <CoreData/CoreData.h>


extern const struct StopAliasAttributes {
	 NSString *old_src_id;
	 NSString *src_code;
	 NSString *src_id;
} StopAliasAttributes;

extern const struct StopAliasRelationships {
	 NSString *stop;
} StopAliasRelationships;

extern const struct StopAliasFetchedProperties {
} StopAliasFetchedProperties;

@class Stop;





@interface StopAliasID : NSManagedObjectID {}
@end

@interface _StopAlias : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopAliasID*)objectID;





@property (nonatomic, retain) NSString* old_src_id;



//- (BOOL)validateOld_src_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* src_code;



//- (BOOL)validateSrc_code:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* src_id;



//- (BOOL)validateSrc_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) Stop *stop;

//- (BOOL)validateStop:(id*)value_ error:(NSError**)error_;





@end

@interface _StopAlias (CoreDataGeneratedAccessors)

@end

@interface _StopAlias (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveOld_src_id;
- (void)setPrimitiveOld_src_id:(NSString*)value;




- (NSString*)primitiveSrc_code;
- (void)setPrimitiveSrc_code:(NSString*)value;




- (NSString*)primitiveSrc_id;
- (void)setPrimitiveSrc_id:(NSString*)value;





- (Stop*)primitiveStop;
- (void)setPrimitiveStop:(Stop*)value;


@end
