// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FormField.m instead.

#import "_FormField.h"

const struct FormFieldAttributes FormFieldAttributes = {
	.fieldDescription = @"fieldDescription",
	.fieldStoreIdentifier = @"fieldStoreIdentifier",
	.fieldTitle = @"fieldTitle",
	.indexPathRow = @"indexPathRow",
	.indexPathSection = @"indexPathSection",
};

const struct FormFieldRelationships FormFieldRelationships = {
	.form = @"form",
};

@implementation FormFieldID
@end

@implementation _FormField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FormField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FormField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FormField" inManagedObjectContext:moc_];
}

- (FormFieldID*)objectID {
	return (FormFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexPathRowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"indexPathRow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"indexPathSectionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"indexPathSection"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic fieldDescription;

@dynamic fieldStoreIdentifier;

@dynamic fieldTitle;

@dynamic indexPathRow;

- (int16_t)indexPathRowValue {
	NSNumber *result = [self indexPathRow];
	return [result shortValue];
}

- (void)setIndexPathRowValue:(int16_t)value_ {
	[self setIndexPathRow:@(value_)];
}

- (int16_t)primitiveIndexPathRowValue {
	NSNumber *result = [self primitiveIndexPathRow];
	return [result shortValue];
}

- (void)setPrimitiveIndexPathRowValue:(int16_t)value_ {
	[self setPrimitiveIndexPathRow:@(value_)];
}

@dynamic indexPathSection;

- (int16_t)indexPathSectionValue {
	NSNumber *result = [self indexPathSection];
	return [result shortValue];
}

- (void)setIndexPathSectionValue:(int16_t)value_ {
	[self setIndexPathSection:@(value_)];
}

- (int16_t)primitiveIndexPathSectionValue {
	NSNumber *result = [self primitiveIndexPathSection];
	return [result shortValue];
}

- (void)setPrimitiveIndexPathSectionValue:(int16_t)value_ {
	[self setPrimitiveIndexPathSection:@(value_)];
}

@dynamic form;

@end

