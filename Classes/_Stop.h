// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Stop.h instead.

#import <CoreData/CoreData.h>


@class ClosePoi;
@class City;
@class Line;
@class StopTime;










@interface StopID : NSManagedObjectID {}
@end

@interface _Stop : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopID*)objectID;



@property (nonatomic, retain) NSNumber *bike_count;

@property short bike_countValue;
- (short)bike_countValue;
- (void)setBike_countValue:(short)value_;

//- (BOOL)validateBike_count:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *src_id;

//- (BOOL)validateSrc_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *metro_count;

@property short metro_countValue;
- (short)metro_countValue;
- (void)setMetro_countValue:(short)value_;

//- (BOOL)validateMetro_count:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDecimalNumber *lon;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDecimalNumber *lat;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *pos_count;

@property short pos_countValue;
- (short)pos_countValue;
- (void)setPos_countValue:(short)value_;

//- (BOOL)validatePos_count:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *line_count;

@property short line_countValue;
- (short)line_countValue;
- (void)setLine_countValue:(short)value_;

//- (BOOL)validateLine_count:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* close_pois;
- (NSMutableSet*)close_poisSet;



@property (nonatomic, retain) City* city;
//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSSet* lines;
- (NSMutableSet*)linesSet;



@property (nonatomic, retain) NSSet* stop_times;
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

- (void)addStop_times:(NSSet*)value_;
- (void)removeStop_times:(NSSet*)value_;
- (void)addStop_timesObject:(StopTime*)value_;
- (void)removeStop_timesObject:(StopTime*)value_;

@end

@interface _Stop (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBike_count;
- (void)setPrimitiveBike_count:(NSNumber*)value;

- (short)primitiveBike_countValue;
- (void)setPrimitiveBike_countValue:(short)value_;


- (NSString*)primitiveSrc_id;
- (void)setPrimitiveSrc_id:(NSString*)value;


- (NSNumber*)primitiveMetro_count;
- (void)setPrimitiveMetro_count:(NSNumber*)value;

- (short)primitiveMetro_countValue;
- (void)setPrimitiveMetro_countValue:(short)value_;


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSDecimalNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSDecimalNumber*)value;


- (NSDecimalNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSDecimalNumber*)value;


- (NSNumber*)primitivePos_count;
- (void)setPrimitivePos_count:(NSNumber*)value;

- (short)primitivePos_countValue;
- (void)setPrimitivePos_countValue:(short)value_;


- (NSNumber*)primitiveLine_count;
- (void)setPrimitiveLine_count:(NSNumber*)value;

- (short)primitiveLine_countValue;
- (void)setPrimitiveLine_countValue:(short)value_;




- (NSMutableSet*)primitiveClose_pois;
- (void)setPrimitiveClose_pois:(NSMutableSet*)value;



- (City*)primitiveCity;
- (void)setPrimitiveCity:(City*)value;



- (NSMutableSet*)primitiveLines;
- (void)setPrimitiveLines:(NSMutableSet*)value;



- (NSMutableSet*)primitiveStop_times;
- (void)setPrimitiveStop_times:(NSMutableSet*)value;


@end
