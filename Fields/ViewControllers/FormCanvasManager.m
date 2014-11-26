
#import "FormCanvasManager.h"
#import "MBCoreDataFetchControllerHelper.h"
#import "FormCanvasInteractor.h"
#import "FieldType.h"
#import "FormField.h"

@interface FormCanvasManager ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) Form *form;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MBCoreDataFetchControllerHelper *fetchControllerHelper;
@property (nonatomic, strong) FormCanvasInteractor *fci;
@end


@implementation FormCanvasManager
@synthesize fetchedResultsController = _fetchedResultsController;

- (instancetype)initWithTableView:(UITableView *)aTableView andForm:(Form *)aForm
{
    self = [super init];
    if (self) {
        self.tableView = aTableView;
        _form = aForm;
        _items = [NSMutableArray array];
        _fetchControllerHelper = [[MBCoreDataFetchControllerHelper alloc] initWithTableView:_tableView usingUpdateCellsBlock:nil];
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView
{
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
    }
    
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
}

- (FormCanvasInteractor *)fci {
    if (!_fci) {
        _fci = [[FormCanvasInteractor alloc] init];
    }
    return _fci;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    
    
    NSFetchRequest *fieldsRequest = [self.fci requestAllFieldsForForm:self.form];
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fieldsRequest
                                        managedObjectContext:self.fci.defaultMOC
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


- (void)addItemsFromArray:(NSArray *)items
{
    [self.items addObjectsFromArray:[items copy]];
    [self.tableView reloadData];
}

- (void)addNewFieldOfType:(FieldType *)type {
}

#pragma mark - UITableViewDataSource methods
// Default is 1. No need to override.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self countItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    id item = self.items[indexPath.row];
    
//    NSString *cellIdentifier = NSStringFromClass([item class]);
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // TEST with cell snapshot
//    [cell addSubview:(UIView *)item];
    FormField *item = (FormField *)[self objectAtIndexPath:indexPath];
    cell.textLabel.text = item.fieldTitle;
    
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}
*/

@end
