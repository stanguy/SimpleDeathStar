// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClosePoi.h instead.

#import <CoreData/CoreData.h>


extern const struct ClosePoiAttributes {
	 NSString *distance;
} ClosePoiAttributes;

extern const struct ClosePoiRelationships {
	 NSString *poi;
} ClosePoiRelationships;

extern const struct ClosePoiFetchedProperties {
} ClosePoiFetchedProperties;

@class Poi;



@interface ClosePoiID : NSManagedObjectID {}
@end

@interface _ClosePoi : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ClosePoiID*)objectID;





@property (nonatomic, retain) NSNumber* distance;



@property int16_t distanceValue;
- (int16_t)distanceValue;
- (void)setDistanceValue:(int16_t)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) Poi *poi;

//- (BOOL)validatePoi:(id*)value_ error:(NSError**)error_;





@end

@interface _ClosePoi (CoreDataGeneratedAccessors)

@end

@interface _ClosePoi (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (int16_t)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(int16_t)value_;





- (Poi*)primitivePoi;
- (void)setPrimitivePoi:(Poi*)value;


@end
