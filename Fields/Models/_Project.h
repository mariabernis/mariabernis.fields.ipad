// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.h instead.

@import CoreData;

extern const struct ProjectAttributes {
	__unsafe_unretained NSString *projectDescription;
	__unsafe_unretained NSString *projectTitle;
	__unsafe_unretained NSString *templatesContainer;
} ProjectAttributes;

@interface ProjectID : NSManagedObjectID {}
@end

@interface _Project : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ProjectID* objectID;

@property (nonatomic, strong) NSString* projectDescription;

//- (BOOL)validateProjectDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* projectTitle;

//- (BOOL)validateProjectTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* templatesContainer;

@property (atomic) BOOL templatesContainerValue;
- (BOOL)templatesContainerValue;
- (void)setTemplatesContainerValue:(BOOL)value_;

//- (BOOL)validateTemplatesContainer:(id*)value_ error:(NSError**)error_;

@end

@interface _Project (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveProjectDescription;
- (void)setPrimitiveProjectDescription:(NSString*)value;

- (NSString*)primitiveProjectTitle;
- (void)setPrimitiveProjectTitle:(NSString*)value;

- (NSNumber*)primitiveTemplatesContainer;
- (void)setPrimitiveTemplatesContainer:(NSNumber*)value;

- (BOOL)primitiveTemplatesContainerValue;
- (void)setPrimitiveTemplatesContainerValue:(BOOL)value_;

@end
