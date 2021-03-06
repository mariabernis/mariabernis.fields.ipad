
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FieldType : NSObject

@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *typeDescription;
@property (nonatomic, strong) UIImage *typeThumbnail;

@property (nonatomic, strong) NSString *typeIdentifier;
@property (nonatomic, strong) NSString *typeDrawer;

@end
