// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Favorite.h instead.

#import <CoreData/CoreData.h>










@interface FavoriteID : NSManagedObjectID {}
@end

@interface _Favorite : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FavoriteID*)objectID;



@property (nonatomic, retain) NSString *stop_id;

//- (BOOL)validateStop_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *line_id;

//- (BOOL)validateLine_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *stop_name;

//- (BOOL)validateStop_name:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *line_short_name;

//- (BOOL)validateLine_short_name:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *view_count;

@property int view_countValue;
- (int)view_countValue;
- (void)setView_countValue:(int)value_;

//- (BOOL)validateView_count:(id*)value_ error:(NSError**)error_;





@end

@interface _Favorite (CoreDataGeneratedAccessors)

@end

@interface _Favorite (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveStop_id;
- (void)setPrimitiveStop_id:(NSString*)value;


- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;


- (NSString*)primitiveLine_id;
- (void)setPrimitiveLine_id:(NSString*)value;


- (NSString*)primitiveStop_name;
- (void)setPrimitiveStop_name:(NSString*)value;


- (NSString*)primitiveLine_short_name;
- (void)setPrimitiveLine_short_name:(NSString*)value;


- (NSNumber*)primitiveView_count;
- (void)setPrimitiveView_count:(NSNumber*)value;

- (int)primitiveView_countValue;
- (void)setPrimitiveView_countValue:(int)value_;



@end
