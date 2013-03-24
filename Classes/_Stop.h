// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.h instead.

#import <CoreData/CoreData.h>


extern const struct StopAttributes {
	 NSString *accessible;
	 NSString *bike_count;
	 NSString *lat;
	 NSString *line_count;
	 NSString *lon;
	 NSString *metro_count;
	 NSString *name;
	 NSString *old_src_id;
	 NSString *pos_count;
	 NSString *slug;
	 NSString *src_id;
} StopAttributes;

extern const struct StopRelationships {
	 NSString *city;
	 NSString *close_pois;
	 NSString *lines;
	 NSString *stop_aliases;
	 NSString *stop_times;
} StopRelationships;

extern const struct StopFetchedProperties {
} StopFetchedProperties;

@class City;
@class ClosePoi;
@class Line;
@class StopAlias;
@class StopTime;













@interface StopID : NSManagedObjectID {}
@end

@interface _Stop : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopID*)objectID;





@property (nonatomic, retain) NSNumber* accessible;



@property BOOL accessibleValue;
- (BOOL)accessibleValue;
- (void)setAccessibleValue:(BOOL)value_;

//- (BOOL)validateAccessible:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* bike_count;



@property int16_t bike_countValue;
- (int16_t)bike_countValue;
- (void)setBike_countValue:(int16_t)value_;

//- (BOOL)validateBike_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSDecimalNumber* lat;



//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* line_count;



@property int16_t line_countValue;
- (int16_t)line_countValue;
- (void)setLine_countValue:(int16_t)value_;

//- (BOOL)validateLine_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSDecimalNumber* lon;



//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* metro_count;



@property int16_t metro_countValue;
- (int16_t)metro_countValue;
- (void)setMetro_countValue:(int16_t)value_;

//- (BOOL)validateMetro_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* old_src_id;



//- (BOOL)validateOld_src_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* pos_count;



@property int16_t pos_countValue;
- (int16_t)pos_countValue;
- (void)setPos_countValue:(int16_t)value_;

//- (BOOL)validatePos_count:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* slug;



//- (BOOL)validateSlug:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* src_id;



//- (BOOL)validateSrc_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) City *city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet *close_pois;

- (NSMutableSet*)close_poisSet;




@property (nonatomic, retain) NSSet *lines;

- (NSMutableSet*)linesSet;




@property (nonatomic, retain) NSSet *stop_aliases;

- (NSMutableSet*)stop_aliasesSet;




@property (nonatomic, retain) NSSet *stop_times;

- (NSMutableSet*)stop_timesSet;





@end

@interface _Stop (CoreDataGeneratedAccessors)

- (void)addClose_pois:(NSSet*)value_;
- (void)removeClose_pois:(NSSet*)value_;
- (void)addClose_poisObject:(ClosePoi*)value_;
- (void)removeClose_poisObject:(ClosePoi*)value_;

- (void)addLines:(NSSet*)value_;
- (void)removeLines:(NSSet*)value_;
- (void)addLinesObject:(Line*)value_;
- (void)removeLinesObject:(Line*)value_;

- (void)addStop_aliases:(NSSet*)value_;
- (void)removeStop_aliases:(NSSet*)value_;
- (void)addStop_aliasesObject:(StopAlias*)value_;
- (void)removeStop_aliasesObject:(StopAlias*)value_;

- (void)addStop_times:(NSSet*)value_;
- (void)removeStop_times:(NSSet*)value_;
- (void)addStop_timesObject:(StopTime*)value_;
- (void)removeStop_timesObject:(StopTime*)value_;

@end

@interface _Stop (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAccessible;
- (void)setPrimitiveAccessible:(NSNumber*)value;

- (BOOL)primitiveAccessibleValue;
- (void)setPrimitiveAccessibleValue:(BOOL)value_;




- (NSNumber*)primitiveBike_count;
- (void)setPrimitiveBike_count:(NSNumber*)value;

- (int16_t)primitiveBike_countValue;
- (void)setPrimitiveBike_countValue:(int16_t)value_;




- (NSDecimalNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSDecimalNumber*)value;




- (NSNumber*)primitiveLine_count;
- (void)setPrimitiveLine_count:(NSNumber*)value;

- (int16_t)primitiveLine_countValue;
- (void)setPrimitiveLine_countValue:(int16_t)value_;




- (NSDecimalNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSDecimalNumber*)value;




- (NSNumber*)primitiveMetro_count;
- (void)setPrimitiveMetro_count:(NSNumber*)value;

- (int16_t)primitiveMetro_countValue;
- (void)setPrimitiveMetro_countValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveOld_src_id;
- (void)setPrimitiveOld_src_id:(NSString*)value;




- (NSNumber*)primitivePos_count;
- (void)setPrimitivePos_count:(NSNumber*)value;

- (int16_t)primitivePos_countValue;
- (void)setPrimitivePos_countValue:(int16_t)value_;




- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;




- (NSString*)primitiveSrc_id;
- (void)setPrimitiveSrc_id:(NSString*)value;





- (City*)primitiveCity;
- (void)setPrimitiveCity:(City*)value;



- (NSMutableSet*)primitiveClose_pois;
- (void)setPrimitiveClose_pois:(NSMutableSet*)value;



- (NSMutableSet*)primitiveLines;
- (void)setPrimitiveLines:(NSMutableSet*)value;



- (NSMutableSet*)primitiveStop_aliases;
- (void)setPrimitiveStop_aliases:(NSMutableSet*)value;



- (NSMutableSet*)primitiveStop_times;
- (void)setPrimitiveStop_times:(NSMutableSet*)value;


@end
