// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Form.h instead.

@import CoreData;

extern const struct FormAttributes {
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateModified;
	__unsafe_unretained NSString *formDescription;
	__unsafe_unretained NSString *formTitle;
	__unsafe_unretained NSString *isTemplate;
} FormAttributes;

extern const struct FormRelationships {
	__unsafe_unretained NSString *fields;
	__unsafe_unretained NSString *project;
} FormRelationships;

@class FormField;
@class Project;

@interface FormID : NSManagedObjectID {}
@end

@interface _Form : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FormID* objectID;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateModified;

//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* formDescription;

//- (BOOL)validateFormDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* formTitle;

//- (BOOL)validateFormTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isTemplate;

@property (atomic) BOOL isTemplateValue;
- (BOOL)isTemplateValue;
- (void)setIsTemplateValue:(BOOL)value_;

//- (BOOL)validateIsTemplate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *fields;

- (NSMutableSet*)fieldsSet;

@property (nonatomic, strong) Project *project;

//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;

@end

@interface _Form (FieldsCoreDataGeneratedAccessors)
- (void)addFields:(NSSet*)value_;
- (void)removeFields:(NSSet*)value_;
- (void)addFieldsObject:(FormField*)value_;
- (void)removeFieldsObject:(FormField*)value_;

@end

@interface _Form (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate*)value;

- (NSString*)primitiveFormDescription;
- (void)setPrimitiveFormDescription:(NSString*)value;

- (NSString*)primitiveFormTitle;
- (void)setPrimitiveFormTitle:(NSString*)value;

- (NSNumber*)primitiveIsTemplate;
- (void)setPrimitiveIsTemplate:(NSNumber*)value;

- (BOOL)primitiveIsTemplateValue;
- (void)setPrimitiveIsTemplateValue:(BOOL)value_;

- (NSMutableSet*)primitiveFields;
- (void)setPrimitiveFields:(NSMutableSet*)value;

- (Project*)primitiveProject;
- (void)setPrimitiveProject:(Project*)value;

@end
