// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TextField.m instead.

#import "_TextField.h"

const struct TextFieldAttributes TextFieldAttributes = {
	.capturedText = @"capturedText",
};

@implementation TextFieldID
@end

@implementation _TextField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TextField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TextField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TextField" inManagedObjectContext:moc_];
}

- (TextFieldID*)objectID {
	return (TextFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic capturedText;

@end

