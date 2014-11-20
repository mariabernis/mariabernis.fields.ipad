
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MBCoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) NSString *persistentStoreFileName; //@"CoreDataHello.sqlite"


/* Designated initializer */
- (instancetype)initWithPersistenStoreFileName:(NSString *)storeFileName
                                  andStoreType:(NSString *)storeType;

+ (instancetype)sharedCDStack;
+ (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

@end
