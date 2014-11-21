
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UITableView, UICollectionView;
@interface MBCoreDataFetchControllerHelper : NSObject<NSFetchedResultsControllerDelegate>

/* Designated initializer for tableViewController */
- (instancetype)initWithTableView:(UITableView *)aTableView
            usingUpdateCellsBlock:(void(^)(NSIndexPath *indexPath))blockForUpdatingCells;

/* Designated initializer for collectionViewController */
- (instancetype)initWithCollectionView:(UICollectionView *)aCollectionView;
@end
