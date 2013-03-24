// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopTime.h instead.

#import <CoreData/CoreData.h>


extern const struct StopTimeAttributes {
	 NSString *arrival;
	 NSString *departure;
	 NSString *stop_sequence;
	 NSString *trip_bearing;
	 NSString *trip_id;
} StopTimeAttributes;

extern const struct StopTimeRelationships {
	 NSString *calendar;
	 NSString *direction;
	 NSString *line;
	 NSString *stop;
} StopTimeRelationships;

extern const struct StopTimeFetchedProperties {
} StopTimeFetchedProperties;

@class GTFSCalendar;
@class Direction;
@class Line;
@class Stop;







@interface StopTimeID : NSManagedObjectID {}
@end

@interface _StopTime : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (StopTimeID*)objectID;





@property (nonatomic, retain) NSNumber* arrival;



@property int32_t arrivalValue;
- (int32_t)arrivalValue;
- (void)setArrivalValue:(int32_t)value_;

//- (BOOL)validateArrival:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* departure;



@property int32_t departureValue;
- (int32_t)departureValue;
- (void)setDepartureValue:(int32_t)value_;

//- (BOOL)validateDeparture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* stop_sequence;



@property int16_t stop_sequenceValue;
- (int16_t)stop_sequenceValue;
- (void)setStop_sequenceValue:(int16_t)value_;

//- (BOOL)validateStop_sequence:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* trip_bearing;



//- (BOOL)validateTrip_bearing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* trip_id;



@property int32_t trip_idValue;
- (int32_t)trip_idValue;
- (void)setTrip_idValue:(int32_t)value_;

//- (BOOL)validateTrip_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) GTFSCalendar *calendar;

//- (BOOL)validateCalendar:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Direction *direction;

//- (BOOL)validateDirection:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Line *line;

//- (BOOL)validateLine:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Stop *stop;

//- (BOOL)validateStop:(id*)value_ error:(NSError**)error_;





@end

@interface _StopTime (CoreDataGeneratedAccessors)

@end

@interface _StopTime (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveArrival;
- (void)setPrimitiveArrival:(NSNumber*)value;

- (int32_t)primitiveArrivalValue;
- (void)setPrimitiveArrivalValue:(int32_t)value_;




- (NSNumber*)primitiveDeparture;
- (void)setPrimitiveDeparture:(NSNumber*)value;

- (int32_t)primitiveDepartureValue;
- (void)setPrimitiveDepartureValue:(int32_t)value_;




- (NSNumber*)primitiveStop_sequence;
- (void)setPrimitiveStop_sequence:(NSNumber*)value;

- (int16_t)primitiveStop_sequenceValue;
- (void)setPrimitiveStop_sequenceValue:(int16_t)value_;




- (NSString*)primitiveTrip_bearing;
- (void)setPrimitiveTrip_bearing:(NSString*)value;




- (NSNumber*)primitiveTrip_id;
- (void)setPrimitiveTrip_id:(NSNumber*)value;

- (int32_t)primitiveTrip_idValue;
- (void)setPrimitiveTrip_idValue:(int32_t)value_;





- (GTFSCalendar*)primitiveCalendar;
- (void)setPrimitiveCalendar:(GTFSCalendar*)value;



- (Direction*)primitiveDirection;
- (void)setPrimitiveDirection:(Direction*)value;



- (Line*)primitiveLine;
- (void)setPrimitiveLine:(Line*)value;



- (Stop*)primitiveStop;
- (void)setPrimitiveStop:(Stop*)value;


@end
