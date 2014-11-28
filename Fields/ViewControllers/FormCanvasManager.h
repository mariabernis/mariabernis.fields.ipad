
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    FormEditingModePreview,
    FormEditingModeDesigning,
    FormEditingModeCapturingData
} FormEditingMode;

@class Form, FormCanvasManager, FormField;

@protocol FormCanvasManagerDelegate <NSObject>

@required
@optional
- (void)formManager:(FormCanvasManager *)formManager didActivateField:(FormField *)field;
- (void)addPhotoButtonPressed:(id)sender forFieldIndexPath:(NSIndexPath *)indexPath;
@end

@interface FormCanvasManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) id<FormCanvasManagerDelegate> delegate;
@property (nonatomic, assign) FormEditingMode editingMode;

/* designated initializer */
- (instancetype)initWithTableView:(UITableView *)aTableView form:(Form *)aForm editingMode:(FormEditingMode)mode delegate:(id<FormCanvasManagerDelegate>)delegate;

- (void)updateFormHeader;
- (void)updateFieldAtIndex:(NSIndexPath *)indexPath withImage:(UIImage *)image;
- (void)duplicateCurrentField;
- (void)deleteCurrentField;

@end
