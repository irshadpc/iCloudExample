// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Item.h instead.

#import <CoreData/CoreData.h>


extern const struct ItemAttributes {
	__unsafe_unretained NSString *amount;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *name;
} ItemAttributes;

extern const struct ItemRelationships {
	__unsafe_unretained NSString *list;
} ItemRelationships;

extern const struct ItemFetchedProperties {
} ItemFetchedProperties;

@class List;





@interface ItemID : NSManagedObjectID {}
@end

@interface _Item : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ItemID*)objectID;




@property (nonatomic, strong) NSNumber* amount;


@property int32_t amountValue;
- (int32_t)amountValue;
- (void)setAmountValue:(int32_t)value_;

//- (BOOL)validateAmount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate* dateUpdated;


//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) List* list;

//- (BOOL)validateList:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _Item (CoreDataGeneratedAccessors)

@end

@interface _Item (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAmount;
- (void)setPrimitiveAmount:(NSNumber*)value;

- (int32_t)primitiveAmountValue;
- (void)setPrimitiveAmountValue:(int32_t)value_;




- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (List*)primitiveList;
- (void)setPrimitiveList:(List*)value;


@end
