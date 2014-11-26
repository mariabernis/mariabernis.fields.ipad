
#import "FieldTypesProvider.h"
#import "FieldType.h"

// Source
#define REPO_FILE_NAME      @"FieldsRepo"
#define REPO_FILE_EXTENSION @"plist"

// API Keys
#define fieldtype_identifier  @"type_identifier"
#define fieldtype_name        @"name"
#define fieldtype_thumbnail   @"thumbnail"
#define fieldtype_description @"short_description"
#define fieldtype_drawerclass @"drawer_classname"


@implementation FieldTypesProvider

- (void)loadFieldTypesWithCompletion:(void(^)(NSArray *fieldTypes, NSError *error))completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:REPO_FILE_NAME ofType:REPO_FILE_EXTENSION];
        NSArray *rawData = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *results = [NSMutableArray array];
        [rawData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *itemInfo = (NSDictionary *)obj;
            FieldType *item = [FieldType new];
            item.typeName = [itemInfo objectForKey:fieldtype_name];
            item.typeDescription = [itemInfo objectForKey:fieldtype_description];
            NSString *imageName = [itemInfo objectForKey:fieldtype_thumbnail];
            item.typeThumbnail = [UIImage imageNamed:imageName];
            
            item.typeIdentifier = [itemInfo objectForKey:fieldtype_identifier];
            item.typeDrawer = [itemInfo objectForKey:fieldtype_drawerclass];
            
            [results addObject:item];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(results, nil);
            }
        });
        
    });
}

@end
