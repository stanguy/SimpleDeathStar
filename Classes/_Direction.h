// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Direction.h instead.

#import <CoreData/CoreData.h>


extern const struct DirectionAttributes {
	 NSString *headsign;
} DirectionAttributes;

extern const struct DirectionRelationships {
	 NSString *line;
	 NSString *stop_times;
} DirectionRelationships;

extern const struct DirectionFetchedProperties {
} DirectionFetchedProperties;

@class Line;
@class StopTime;



@interface DirectionID : NSManagedObjectID {}
@end

@interface _Direction : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DirectionID*)objectID;





@property (nonatomic, retain) NSString* headsign;



//- (BOOL)validateHeadsign:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) Line *line;

//- (BOOL)validateLine:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet *stop_times;

- (NSMutableSet*)stop_timesSet;





@end

@interface _Direction (CoreDataGeneratedAccessors)

- (void)addStop_times:(NSSet*)value_;
- (void)removeStop_times:(NSSet*)value_;
- (void)addStop_timesObject:(StopTime*)value_;
- (void)removeStop_timesObject:(StopTime*)value_;

@end

@interface _Direction (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveHeadsign;
- (void)setPrimitiveHeadsign:(NSString*)value;





- (Line*)primitiveLine;
- (void)setPrimitiveLine:(Line*)value;



- (NSMutableSet*)primitiveStop_times;
- (void)setPrimitiveStop_times:(NSMutableSet*)value;


@end
