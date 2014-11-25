#import <UIKit/UIKit.h>

@class MBCBaseOptionsChooser;

/**
 *  Protocol to communicate between BaseOptionsChooser and the presenting view controller.
 */
@protocol MBCBaseOptionsChooserDelegate <NSObject>

@required
/**
 *  Configure here your custom cells. Required. 
 */
- (void)chooserControllerConfigureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
/**
 *  Tells the delegate an item was selected in the BaseOptionsChooser list.
 *
 *  @param controller BaseOptionsChooser sending the event.
 *  @param item       The selected item.
 */
-(void)chooserController:(MBCBaseOptionsChooser *)controller didSelectItem:(id)item;

@optional
@end

// TO-DO would be nice to refactor this class to take two blocks as arguments:
// a block for updating cells and a block for the selection action. 

/**
 *  Base view controller for displaying a selectable list of options. One single option can be choosed.
 */
@interface MBCBaseOptionsChooser : UITableViewController
@property (weak, nonatomic) id <MBCBaseOptionsChooserDelegate> delegate;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) id selected;

@end
