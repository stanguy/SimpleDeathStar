// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GTFSCalendar.h instead.

#import <CoreData/CoreData.h>


extern const struct GTFSCalendarAttributes {
	 NSString *days;
	 NSString *end_date;
	 NSString *start_date;
} GTFSCalendarAttributes;

extern const struct GTFSCalendarRelationships {
	 NSString *calendar_dates;
	 NSString *stoptimes;
} GTFSCalendarRelationships;

extern const struct GTFSCalendarFetchedProperties {
} GTFSCalendarFetchedProperties;

@class GTFSCalendarDate;
@class StopTime;





@interface GTFSCalendarID : NSManagedObjectID {}
@end

@interface _GTFSCalendar : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GTFSCalendarID*)objectID;





@property (nonatomic, retain) NSNumber* days;



@property int16_t daysValue;
- (int16_t)daysValue;
- (void)setDaysValue:(int16_t)value_;

//- (BOOL)validateDays:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSDate* end_date;



//- (BOOL)validateEnd_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSDate* start_date;



//- (BOOL)validateStart_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet *calendar_dates;

- (NSMutableSet*)calendar_datesSet;




@property (nonatomic, retain) NSSet *stoptimes;

- (NSMutableSet*)stoptimesSet;





@end

@interface _GTFSCalendar (CoreDataGeneratedAccessors)

- (void)addCalendar_dates:(NSSet*)value_;
- (void)removeCalendar_dates:(NSSet*)value_;
- (void)addCalendar_datesObject:(GTFSCalendarDate*)value_;
- (void)removeCalendar_datesObject:(GTFSCalendarDate*)value_;

- (void)addStoptimes:(NSSet*)value_;
- (void)removeStoptimes:(NSSet*)value_;
- (void)addStoptimesObject:(StopTime*)value_;
- (void)removeStoptimesObject:(StopTime*)value_;

@end

@interface _GTFSCalendar (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDays;
- (void)setPrimitiveDays:(NSNumber*)value;

- (int16_t)primitiveDaysValue;
- (void)setPrimitiveDaysValue:(int16_t)value_;




- (NSDate*)primitiveEnd_date;
- (void)setPrimitiveEnd_date:(NSDate*)value;




- (NSDate*)primitiveStart_date;
- (void)setPrimitiveStart_date:(NSDate*)value;





- (NSMutableSet*)primitiveCalendar_dates;
- (void)setPrimitiveCalendar_dates:(NSMutableSet*)value;



- (NSMutableSet*)primitiveStoptimes;
- (void)setPrimitiveStoptimes:(NSMutableSet*)value;


@end
