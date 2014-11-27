
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class Form;
@interface FormCanvasManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
- (instancetype)initWithTableView:(UITableView *)aTableView andForm:(Form *)aForm;
- (void)addItemsFromArray:(NSArray *)items;
@end
