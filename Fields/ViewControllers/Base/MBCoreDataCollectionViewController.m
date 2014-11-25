
#import "MBCoreDataCollectionViewController.h"
#import "MBCoreDataFetchControllerHelper.h"

@interface MBCoreDataCollectionViewController ()
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MBCoreDataFetchControllerHelper *fetchControllerHelper;
@end

@implementation MBCoreDataCollectionViewController
@synthesize fetchedResultsController = _fetchedResultsController;

// Lazy getter
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSAssert(self.fetchRequest != nil, @"🙉 You need to pass the request!");
    NSAssert(self.managedObjectContext != nil, @"🙈 Pass in a context!!");
    
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil           // We  are not grouping here.
                                                   cacheName:@"Master"];  // Important for performance.
    _fetchedResultsController.delegate = self.fetchControllerHelper;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"😱💾 Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.fetchControllerHelper = [[MBCoreDataFetchControllerHelper alloc] initWithCollectionView:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.fetchedResultsController sections] count];;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

    return [self countItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReusableIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark Datasource helpers

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)countItemsInFirstSection {
    return [self countItemsInSection:0];
}

- (NSInteger)countItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoForSectionIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    return count;
}

- (id<NSFetchedResultsSectionInfo>)sectionInfoForSectionIndex:(NSInteger)section {
    return [self.fetchedResultsController sections][section];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


#pragma mark <UICollectionViewDelegate>
/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 
 
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */





@end
