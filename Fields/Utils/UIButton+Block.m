
#import "UIButton+Block.h"
#import <objc/runtime.h>


static NSString * const key_ActionBlock = @"actionBlock";

@implementation UIButton (Block)

- (void)setActionBlock:(ButtonActionBlock)actionBlock
{
    // We need the association COPY because this is a copy property (because it is a block).
    objc_setAssociatedObject(self,
                             (__bridge const void *)(key_ActionBlock),
                             actionBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self
             action:@selector(buttonPressed)
   forControlEvents:UIControlEventTouchUpInside];
}

- (ButtonActionBlock)actionBlock
{
    return objc_getAssociatedObject(self,
                                    (__bridge const void *)(key_ActionBlock));
}


- (instancetype)initWithActionBlock:(ButtonActionBlock)anActionBlock
{
    self = [super init];
    if (self) {
        // We cannot use here the ivar assigment _actionBlock = blabla
        // There is no ivar. So we use the self.propertyName.
        self.actionBlock = anActionBlock;
    }
    return self;
}

- (void)buttonPressed
{
    self.actionBlock();
}


@end
