
#import <UIKit/UIKit.h>

@interface FieldPropsTabView : UIView

@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UITextView *inputDescription;

@property (weak, nonatomic) IBOutlet UIView *actionDuplicateView;
@property (weak, nonatomic) IBOutlet UIView *actionDeleteView;

@property (nonatomic) BOOL activeOptions;

- (void)addDelegateForInputs:(id<UITextFieldDelegate, UITextViewDelegate>)inputsDelegate;

@end
