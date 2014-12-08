
#import "FormPropsTabView.h"

@interface FormPropsTabView ()

@end


@implementation FormPropsTabView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)addDelegateForInputs:(id<UITextFieldDelegate, UITextViewDelegate>)inputsDelegate {
    
    if (!inputsDelegate) {
        return;
    }
    
    if (self.inputTitle.delegate) {
        [self.inputTitle setDelegate:nil];
    }
    
    if (self.inputDescription.delegate) {
        [self.inputDescription setDelegate:nil];
    }
    
    self.inputTitle.delegate = inputsDelegate;
    self.inputDescription.delegate = inputsDelegate;
}

@end
