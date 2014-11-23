
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface MBCoreDataStack : NSObject

//@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, copy) NSString *persistentStoreFileName; //@"MBCFields.sqlite"


/* Designated initializer */
//- (instancetype)initWithPersistenStoreFileName:(NSString *)storeFileName
//                                  andStoreType:(NSString *)storeType;
//
//+ (instancetype)sharedCDStack;
//+ (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSManagedObjectContext *) defaultManagedObjectContext;

+ (void) setupCoreDataStackWithInMemoryStore;

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

@end
