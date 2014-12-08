
#import <UIKit/UIKit.h>
#import "MBCoreDataStack.h"

@interface MBCoreDataTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic) CGFloat defaultCellHeight;
@property (nonatomic, strong) NSString *cellReusableIdentifier;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countItemsInFirstSection;
- (NSInteger)countItemsInSection:(NSInteger)section;
- (id<NSFetchedResultsSectionInfo>)sectionInfoForSectionIndex:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
