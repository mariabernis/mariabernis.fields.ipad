
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class Form, FormCanvasManager, FormField;

@protocol FormCanvasManagerDelegate <NSObject>

@required
- (void)formManager:(FormCanvasManager *)formManager didActivateField:(FormField *)field;

@optional
@end

@interface FormCanvasManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) id<FormCanvasManagerDelegate> delegate;


- (instancetype)initWithTableView:(UITableView *)aTableView form:(Form *)aForm  delegate:(id<FormCanvasManagerDelegate>)delegate;

@end
