
#import <UIKit/UIKit.h>

typedef void (^ButtonActionBlock)();

@interface UIButton (Block)
@property (copy, nonatomic) ButtonActionBlock actionBlock;
- (instancetype)initWithActionBlock:(ButtonActionBlock)anActionBlock;
- (void)setActionBlock:(ButtonActionBlock)actionBlock; // So we get autocompletion for the fucking block syntax. 
@end
