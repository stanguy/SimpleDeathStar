// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Poi.h instead.

#import <CoreData/CoreData.h>









@interface PoiID : NSManagedObjectID {}
@end

@interface _Poi : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PoiID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *lat;

@property float latValue;
- (float)latValue;
- (void)setLatValue:(float)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *lon;

@property float lonValue;
- (float)lonValue;
- (void)setLonValue:(float)value_;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@end

@interface _Poi (CoreDataGeneratedAccessors)

@end

@interface _Poi (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;


- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (float)primitiveLatValue;
- (void)setPrimitiveLatValue:(float)value_;


- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (float)primitiveLonValue;
- (void)setPrimitiveLonValue:(float)value_;


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;



@end
