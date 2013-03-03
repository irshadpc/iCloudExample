// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to List.h instead.

#import <CoreData/CoreData.h>


extern const struct ListAttributes {
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *name;
} ListAttributes;

extern const struct ListRelationships {
	__unsafe_unretained NSString *items;
} ListRelationships;

extern const struct ListFetchedProperties {
} ListFetchedProperties;

@class Item;




@interface ListID : NSManagedObjectID {}
@end

@interface _List : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ListID*)objectID;




@property (nonatomic, strong) NSDate* dateUpdated;


//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* items;

- (NSMutableSet*)itemsSet;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController *)newItemsFetchedResultsControllerWithSortDescriptors:(NSArray *)sortDescriptors;


#endif

@end

@interface _List (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(Item*)value_;
- (void)removeItemsObject:(Item*)value_;

@end

@interface _List (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
