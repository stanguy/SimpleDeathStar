// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Agency.h instead.

#import <CoreData/CoreData.h>


extern const struct AgencyAttributes {
	 NSString *ads_allowed;
	 NSString *city;
	 NSString *feed_ref;
	 NSString *feed_url;
} AgencyAttributes;

extern const struct AgencyRelationships {
} AgencyRelationships;

extern const struct AgencyFetchedProperties {
} AgencyFetchedProperties;







@interface AgencyID : NSManagedObjectID {}
@end

@interface _Agency : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AgencyID*)objectID;





@property (nonatomic, retain) NSNumber* ads_allowed;



@property BOOL ads_allowedValue;
- (BOOL)ads_allowedValue;
- (void)setAds_allowedValue:(BOOL)value_;

//- (BOOL)validateAds_allowed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* feed_ref;



//- (BOOL)validateFeed_ref:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* feed_url;



//- (BOOL)validateFeed_url:(id*)value_ error:(NSError**)error_;






@end

@interface _Agency (CoreDataGeneratedAccessors)

@end

@interface _Agency (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAds_allowed;
- (void)setPrimitiveAds_allowed:(NSNumber*)value;

- (BOOL)primitiveAds_allowedValue;
- (void)setPrimitiveAds_allowedValue:(BOOL)value_;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveFeed_ref;
- (void)setPrimitiveFeed_ref:(NSString*)value;




- (NSString*)primitiveFeed_url;
- (void)setPrimitiveFeed_url:(NSString*)value;




@end
