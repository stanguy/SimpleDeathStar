// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to City.h instead.

#import <CoreData/CoreData.h>


@class Stop;



@interface CityID : NSManagedObjectID {}
@end

@interface _City : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CityID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* stops;
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




- (NSMutableSet*)primitiveStops;
- (void)setPrimitiveStops:(NSMutableSet*)value;


@end
