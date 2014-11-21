
#import <UIKit/UIKit.h>
#import "MBCoreDataStack.h"

@interface MBCoreDataCollectionViewController : UICollectionViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic) CGFloat defaultCellHeight;
@property (nonatomic, strong) NSString *cellReusableIdentifier;

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)mb_countItemsInFirstSection;
- (NSInteger)mb_countItemsInSection:(NSInteger)section;

@end
