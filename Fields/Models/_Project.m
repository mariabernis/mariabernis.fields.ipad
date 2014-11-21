// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.m instead.

#import "_Project.h"

const struct ProjectAttributes ProjectAttributes = {
	.projectDescription = @"projectDescription",
	.projectTitle = @"projectTitle",
	.templatesContainer = @"templatesContainer",
};

@implementation ProjectID
@end

@implementation _Project

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Project";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:moc_];
}

- (ProjectID*)objectID {
	return (ProjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"templatesContainerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"templatesContainer"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic projectDescription;

@dynamic projectTitle;

@dynamic templatesContainer;

- (BOOL)templatesContainerValue {
	NSNumber *result = [self templatesContainer];
	return [result boolValue];
}

- (void)setTemplatesContainerValue:(BOOL)value_ {
	[self setTemplatesContainer:@(value_)];
}

- (BOOL)primitiveTemplatesContainerValue {
	NSNumber *result = [self primitiveTemplatesContainer];
	return [result boolValue];
}

- (void)setPrimitiveTemplatesContainerValue:(BOOL)value_ {
	[self setPrimitiveTemplatesContainer:@(value_)];
}

@end

