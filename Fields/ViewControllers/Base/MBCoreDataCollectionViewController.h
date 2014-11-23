
#import <UIKit/UIKit.h>
#import "MBCoreDataStack.h"

@interface MBCoreDataCollectionViewController : UICollectionViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic) CGFloat defaultCellHeight;
@property (nonatomic, strong) NSString *cellReusableIdentifier;

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countItemsInFirstSection;
- (NSInteger)countItemsInSection:(NSInteger)section;
- (id<NSFetchedResultsSectionInfo>)sectionInfoForSectionIndex:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
