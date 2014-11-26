
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface FormTableViewManager : NSObject <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithTableView:(UITableView *)aTableView;
- (void)addItemsFromArray:(NSArray *)items;
@end
