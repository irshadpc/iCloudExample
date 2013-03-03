// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Item.m instead.

#import "_Item.h"

const struct ItemAttributes ItemAttributes = {
	.amount = @"amount",
	.dateUpdated = @"dateUpdated",
	.name = @"name",
};

const struct ItemRelationships ItemRelationships = {
	.list = @"list",
};

const struct ItemFetchedProperties ItemFetchedProperties = {
};

@implementation ItemID
@end

@implementation _Item

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Item";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Item" inManagedObjectContext:moc_];
}

- (ItemID*)objectID {
	return (ItemID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"amountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"amount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic amount;



- (int32_t)amountValue {
	NSNumber *result = [self amount];
	return [result intValue];
}

- (void)setAmountValue:(int32_t)value_ {
	[self setAmount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAmountValue {
	NSNumber *result = [self primitiveAmount];
	return [result intValue];
}

- (void)setPrimitiveAmountValue:(int32_t)value_ {
	[self setPrimitiveAmount:[NSNumber numberWithInt:value_]];
}





@dynamic dateUpdated;






@dynamic name;






@dynamic list;

	






#if TARGET_OS_IPHONE



#endif

@end
