
#import <UIKit/UIKit.h>
#import "BaseFieldCell.h"

@interface TextFieldCell : BaseFieldCell

@property (weak, nonatomic) IBOutlet UILabel *fieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *fieldDescription;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
