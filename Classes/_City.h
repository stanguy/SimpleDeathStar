// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to City.h instead.

#import <CoreData/CoreData.h>


extern const struct CityAttributes {
	 NSString *name;
	 NSString *stop_count;
} CityAttributes;

extern const struct CityRelationships {
	 NSString *stops;
} CityRelationships;

extern const struct CityFetchedProperties {
} CityFetchedProperties;

@class Stop;




@interface CityID : NSManagedObjectID {}
@end

@interface _City : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CityID*)objectID;





@property (nonatomic, retain) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* stop_count;



@property int16_t stop_countValue;
- (int16_t)stop_countValue;
- (void)setStop_countValue:(int16_t)value_;

//- (BOOL)validateStop_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet *stops;

- (NSMutableSet*)stopsSet;





@end

@interface _City (CoreDataGeneratedAccessors)

- (void)addStops:(NSSet*)value_;
- (void)removeStops:(NSSet*)value_;
- (void)addStopsObject:(Stop*)value_;
- (void)removeStopsObject:(Stop*)value_;

@end

@interface _City (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveStop_count;
- (void)setPrimitiveStop_count:(NSNumber*)value;

- (int16_t)primitiveStop_countValue;
- (void)setPrimitiveStop_countValue:(int16_t)value_;





- (NSMutableSet*)primitiveStops;
- (void)setPrimitiveStops:(NSMutableSet*)value;


@end
