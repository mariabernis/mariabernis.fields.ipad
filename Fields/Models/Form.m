#import "Form.h"
#import "Project.h"

@interface Form ()

// Private interface goes here.

@end

@implementation Form

- (void)awakeFromInsert {
    [super awakeFromInsert];
    NSDate *now = [NSDate date];
    [self setPrimitiveDateCreated:now];
    [self setPrimitiveDateModified:now];
}

//- (BOOL)isTemplateValue {
//    return [super isTemplateValue];
//}
//
//- (void)setIsTemplateValue:(BOOL)value_ {
//    NSAssert(false, @"This a read-only property");
//}

- (void)customSetProject:(Project *)project {
    self.project = project;
    [self setIsTemplateValue:[project isTemplateContainer]];
}

@end
