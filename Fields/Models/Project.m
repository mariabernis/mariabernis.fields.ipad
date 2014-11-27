#import "Project.h"

@interface Project ()

@end


@implementation Project

- (void)awakeFromInsert {
    [super awakeFromInsert];
    NSDate *now = [NSDate date];
    [self setPrimitiveDateCreated:now];
    [self setPrimitiveDateModified:now];
}

- (BOOL)isTemplateContainer {
    return [self templatesContainerValue];
}

@end
