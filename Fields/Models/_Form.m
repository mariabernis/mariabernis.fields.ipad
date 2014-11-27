// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Form.m instead.

#import "_Form.h"

const struct FormAttributes FormAttributes = {
	.dateCreated = @"dateCreated",
	.dateModified = @"dateModified",
	.formDescription = @"formDescription",
	.formTitle = @"formTitle",
	.isTemplate = @"isTemplate",
};

const struct FormRelationships FormRelationships = {
	.project = @"project",
};

@implementation FormID
@end

@implementation _Form

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Form" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Form";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Form" inManagedObjectContext:moc_];
}

- (FormID*)objectID {
	return (FormID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isTemplateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isTemplate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic dateCreated;

@dynamic dateModified;

@dynamic formDescription;

@dynamic formTitle;

@dynamic isTemplate;

- (BOOL)isTemplateValue {
	NSNumber *result = [self isTemplate];
	return [result boolValue];
}

- (void)setIsTemplateValue:(BOOL)value_ {
	[self setIsTemplate:@(value_)];
}

- (BOOL)primitiveIsTemplateValue {
	NSNumber *result = [self primitiveIsTemplate];
	return [result boolValue];
}

- (void)setPrimitiveIsTemplateValue:(BOOL)value_ {
	[self setPrimitiveIsTemplate:@(value_)];
}

@dynamic project;

@end

