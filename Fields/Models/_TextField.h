// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TextField.h instead.

@import CoreData;
#import "FormField.h"

extern const struct TextFieldAttributes {
	__unsafe_unretained NSString *capturedText;
} TextFieldAttributes;

@interface TextFieldID : FormFieldID {}
@end

@interface _TextField : FormField {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TextFieldID* objectID;

@property (nonatomic, strong) NSString* capturedText;

//- (BOOL)validateCapturedText:(id*)value_ error:(NSError**)error_;

@end

@interface _TextField (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCapturedText;
- (void)setPrimitiveCapturedText:(NSString*)value;

@end
