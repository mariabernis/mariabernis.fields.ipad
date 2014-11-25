

#import <UIKit/UIKit.h>

@interface FormPropsTabView : UIView
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UITextView *inputDescription;
@property (weak, nonatomic) IBOutlet UILabel *projChooserLabel;
@property (weak, nonatomic) IBOutlet UIView *projChooserView;
@property (weak, nonatomic) IBOutlet UIView *actionDuplicateView;
@property (weak, nonatomic) IBOutlet UIView *actionDeleteView;
@end
