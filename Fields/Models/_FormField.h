// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FormField.h instead.

@import CoreData;

extern const struct FormFieldAttributes {
	__unsafe_unretained NSString *fieldDescription;
	__unsafe_unretained NSString *fieldStoreIdentifier;
	__unsafe_unretained NSString *fieldTitle;
	__unsafe_unretained NSString *indexPathRow;
	__unsafe_unretained NSString *indexPathSection;
} FormFieldAttributes;

extern const struct FormFieldRelationships {
	__unsafe_unretained NSString *form;
} FormFieldRelationships;

@class Form;

@interface FormFieldID : NSManagedObjectID {}
@end

@interface _FormField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FormFieldID* objectID;

@property (nonatomic, strong) NSString* fieldDescription;

//- (BOOL)validateFieldDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fieldStoreIdentifier;

//- (BOOL)validateFieldStoreIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fieldTitle;

//- (BOOL)validateFieldTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* indexPathRow;

@property (atomic) int16_t indexPathRowValue;
- (int16_t)indexPathRowValue;
- (void)setIndexPathRowValue:(int16_t)value_;

//- (BOOL)validateIndexPathRow:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* indexPathSection;

@property (atomic) int16_t indexPathSectionValue;
- (int16_t)indexPathSectionValue;
- (void)setIndexPathSectionValue:(int16_t)value_;

//- (BOOL)validateIndexPathSection:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Form *form;

//- (BOOL)validateForm:(id*)value_ error:(NSError**)error_;

@end

@interface _FormField (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFieldDescription;
- (void)setPrimitiveFieldDescription:(NSString*)value;

- (NSString*)primitiveFieldStoreIdentifier;
- (void)setPrimitiveFieldStoreIdentifier:(NSString*)value;

- (NSString*)primitiveFieldTitle;
- (void)setPrimitiveFieldTitle:(NSString*)value;

- (NSNumber*)primitiveIndexPathRow;
- (void)setPrimitiveIndexPathRow:(NSNumber*)value;

- (int16_t)primitiveIndexPathRowValue;
- (void)setPrimitiveIndexPathRowValue:(int16_t)value_;

- (NSNumber*)primitiveIndexPathSection;
- (void)setPrimitiveIndexPathSection:(NSNumber*)value;

- (int16_t)primitiveIndexPathSectionValue;
- (void)setPrimitiveIndexPathSectionValue:(int16_t)value_;

- (Form*)primitiveForm;
- (void)setPrimitiveForm:(Form*)value;

@end
