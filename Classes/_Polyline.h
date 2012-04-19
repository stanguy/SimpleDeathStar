// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Polyline.h instead.

#import <CoreData/CoreData.h>


@class Line;



@interface PolylineID : NSManagedObjectID {}
@end

@interface _Polyline : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PolylineID*)objectID;



@property (nonatomic, retain) NSString *path;

//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Line* line;
//- (BOOL)validateLine:(id*)value_ error:(NSError**)error_;




@end

@interface _Polyline (CoreDataGeneratedAccessors)

@end

@interface _Polyline (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitivePath;
- (void)setPrimitivePath:(NSString*)value;




- (Line*)primitiveLine;
- (void)setPrimitiveLine:(Line*)value;


@end
