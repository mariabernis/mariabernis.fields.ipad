// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ImageField.h instead.

@import CoreData;
#import "FormField.h"

extern const struct ImageFieldAttributes {
	__unsafe_unretained NSString *capturedImage;
} ImageFieldAttributes;

@class NSObject;

@interface ImageFieldID : FormFieldID {}
@end

@interface _ImageField : FormField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ImageFieldID* objectID;

@property (nonatomic, strong) id capturedImage;

//- (BOOL)validateCapturedImage:(id*)value_ error:(NSError**)error_;

@end

@interface _ImageField (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveCapturedImage;
- (void)setPrimitiveCapturedImage:(id)value;

@end
