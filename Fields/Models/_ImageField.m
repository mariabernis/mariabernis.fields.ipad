// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ImageField.m instead.

#import "_ImageField.h"

const struct ImageFieldAttributes ImageFieldAttributes = {
	.capturedImage = @"capturedImage",
};

@implementation ImageFieldID
@end

@implementation _ImageField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ImageField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ImageField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ImageField" inManagedObjectContext:moc_];
}

- (ImageFieldID*)objectID {
	return (ImageFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic capturedImage;

@end

