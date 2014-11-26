
#import "MBCoreDataFetchControllerHelper.h"
#import <UIKit/UIKit.h>


@interface MBCoreDataFetchControllerHelper ()
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) void (^blockToExecuteWhenYouNeedToUpdateYourCell)(NSIndexPath *indexPath);
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionSectionChanges;
@property (nonatomic, strong) NSMutableArray *collectionItemChanges;

@end

@implementation MBCoreDataFetchControllerHelper

/* Designated initializer for tableViewController */
- (instancetype)initWithTableView:(UITableView *)aTableView
            usingUpdateCellsBlock:(void(^)(NSIndexPath *indexPath))blockForUpdatingCells
{
    self = [super init];
    if (self) {
        _tableView = aTableView;
        _blockToExecuteWhenYouNeedToUpdateYourCell = blockForUpdatingCells;
    }
    return self;
}

/* Designated initializer for collectionViewController */
- (instancetype)initWithCollectionView:(UICollectionView *)aCollectionView
{
    self = [super init];
    if (self) {
        _collectionView = aCollectionView;
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"USE DESIGNATED INITIALIZER");
    return nil;
}

#pragma mark - TableView implementation
- (void)tableViewBeginUpdates
{
    [self.tableView beginUpdates];
}

- (void)tableViewUpdateSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                       atIndex:(NSUInteger)sectionIndex
                 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)tableViewDidChangeObject:(id)anObject
                     atIndexPath:(NSIndexPath *)indexPath
                   forChangeType:(NSFetchedResultsChangeType)type
                    newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableV = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableV insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            self.blockToExecuteWhenYouNeedToUpdateYourCell(indexPath);
            break;
            
        case NSFetchedResultsChangeMove:
            [tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableV insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)tableViewEndUpdates
{
    [self.tableView endUpdates];
}

#pragma mark - CollectionView implementation
- (void)collectionViewBeginUpdates
{
    self.collectionSectionChanges = [[NSMutableArray alloc] init];
    self.collectionItemChanges = [[NSMutableArray alloc] init];
}

- (void)collectionViewUpdateSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                            atIndex:(NSUInteger)sectionIndex
                      forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [self.collectionSectionChanges addObject:change];
}

- (void)collectionViewDidChangeObject:(id)anObject
                          atIndexPath:(NSIndexPath *)indexPath
                        forChangeType:(NSFetchedResultsChangeType)type
                         newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [self.collectionItemChanges addObject:change];
}

- (void)collectionViewEndUpdates
{
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in self.collectionSectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                        
                    default:
                        break;
                }
            }];
        }
        for (NSDictionary *change in self.collectionItemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                        
                    default:
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        self.collectionSectionChanges = nil;
        self.collectionItemChanges = nil;
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.tableView) {
        [self tableViewBeginUpdates];
    } else {
        [self collectionViewBeginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.tableView) {
        [self tableViewUpdateSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    } else {
        [self collectionViewUpdateSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.tableView) {
        [self tableViewDidChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    } else {
        [self collectionViewDidChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.tableView) {
        [self tableViewEndUpdates];
    } else {
        [self collectionViewEndUpdates];
    }
    
}


@end
