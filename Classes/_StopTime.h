// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to StopTime.h instead.

#import <CoreData/CoreData.h>


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



@property (nonatomic, retain) NSNumber *arrival;

@property int arrivalValue;
- (int)arrivalValue;
- (void)setArrivalValue:(int)value_;

//- (BOOL)validateArrival:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *trip_id;

@property int trip_idValue;
- (int)trip_idValue;
- (void)setTrip_idValue:(int)value_;

//- (BOOL)validateTrip_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *calendar;

@property short calendarValue;
- (short)calendarValue;
- (void)setCalendarValue:(short)value_;

//- (BOOL)validateCalendar:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *trip_bearing;

//- (BOOL)validateTrip_bearing:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *departure;

@property int departureValue;
- (int)departureValue;
- (void)setDepartureValue:(int)value_;

//- (BOOL)validateDeparture:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Direction* direction;
//- (BOOL)validateDirection:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) Line* line;
//- (BOOL)validateLine:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) Stop* stop;
//- (BOOL)validateStop:(id*)value_ error:(NSError**)error_;




+ (NSArray*)fetchStopTimeComing:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchStopTimeComing:(NSManagedObjectContext*)moc_ error:(NSError**)error_;



@end

@interface _StopTime (CoreDataGeneratedAccessors)

@end

@interface _StopTime (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveArrival;
- (void)setPrimitiveArrival:(NSNumber*)value;

- (int)primitiveArrivalValue;
- (void)setPrimitiveArrivalValue:(int)value_;


- (NSNumber*)primitiveTrip_id;
- (void)setPrimitiveTrip_id:(NSNumber*)value;

- (int)primitiveTrip_idValue;
- (void)setPrimitiveTrip_idValue:(int)value_;


- (NSNumber*)primitiveCalendar;
- (void)setPrimitiveCalendar:(NSNumber*)value;

- (short)primitiveCalendarValue;
- (void)setPrimitiveCalendarValue:(short)value_;


- (NSString*)primitiveTrip_bearing;
- (void)setPrimitiveTrip_bearing:(NSString*)value;


- (NSNumber*)primitiveDeparture;
- (void)setPrimitiveDeparture:(NSNumber*)value;

- (int)primitiveDepartureValue;
- (void)setPrimitiveDepartureValue:(int)value_;




- (Direction*)primitiveDirection;
- (void)setPrimitiveDirection:(Direction*)value;



- (Line*)primitiveLine;
- (void)setPrimitiveLine:(Line*)value;



- (Stop*)primitiveStop;
- (void)setPrimitiveStop:(Stop*)value;


@end
