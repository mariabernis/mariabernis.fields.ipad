
#import "FormTableViewManager.h"
#import "MBCoreDataFetchControllerHelper.h"


@interface FormTableViewManager ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBCoreDataFetchControllerHelper *fetchControllerHelper;
@end


@implementation FormTableViewManager

- (instancetype)initWithTableView:(UITableView *)aTableView
{
    self = [super init];
    if (self) {
        self.tableView = aTableView;
        _items = [NSMutableArray array];
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

- (void)addItemsFromArray:(NSArray *)items
{
    [self.items addObjectsFromArray:[items copy]];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource methods
// Default is 1. No need to override.
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.items[indexPath.row];
    
//    NSString *cellIdentifier = NSStringFromClass([item class]);
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // TEST with cell snapshot
    [cell addSubview:(UIView *)item];
    
    
    return cell;
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
