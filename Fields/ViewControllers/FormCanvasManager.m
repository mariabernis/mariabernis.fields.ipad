
#import "FormCanvasManager.h"
#import "MBCoreDataFetchControllerHelper.h"
#import "FormCanvasInteractor.h"
#import "FieldType.h"
//#import "FormField.h"
#import "TextField.h"
#import "ImageField.h"
#import "TextFieldCell.h"
#import "ImageFieldCell.h"
#import "Form.h"
#import "Project.h"
#import "UIButton+Block.h"
#import "FormFieldInteractor.h"

@interface FormCanvasManager ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) Form *form;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MBCoreDataFetchControllerHelper *fetchControllerHelper;
@property (nonatomic, strong) FormCanvasInteractor *fci;
@property (nonatomic, strong) FormFieldInteractor *ffi;
@property (nonatomic, strong) NSIndexPath *activeFieldIndex;
@property (nonatomic, weak) UILabel *formTitleLabel;
@property (nonatomic, weak) UILabel *formProjectLabel;
@property (nonatomic, weak) UILabel *formDescLabel;


@end


@implementation FormCanvasManager
@synthesize fetchedResultsController = _fetchedResultsController;

- (instancetype)initWithTableView:(UITableView *)aTableView form:(Form *)aForm editingMode:(FormEditingMode)mode delegate:(id<FormCanvasManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _form = aForm;
        _delegate = delegate;
        _editingMode = mode;
        _items = [NSMutableArray array];
        self.tableView = aTableView;
        
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
    switch (self.editingMode) {
        case FormEditingModePreview:
        case FormEditingModeCapturingData:
            _tableView.allowsSelection = NO;
            break;
            
        default:
            _tableView.allowsSelection = YES;
            break;
    }
    
    [self setupHeaderView];
}

- (FormCanvasInteractor *)fci {
    if (!_fci) {
        _fci = [[FormCanvasInteractor alloc] init];
    }
    return _fci;
}

- (FormFieldInteractor *)ffi {
    if (!_ffi) {
        _ffi = [[FormFieldInteractor alloc] init];
    }
    return _ffi;
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

- (void)setupHeaderView {
    UIView *headerView = self.tableView.tableHeaderView;
    if (!headerView) {
        // Create it
    }
    self.formTitleLabel = headerView.subviews[0];
    self.formProjectLabel = headerView.subviews[1];
    self.formDescLabel = headerView.subviews[2];
    [self updateFormHeader];
}

- (void)updateFormHeader {
    self.formTitleLabel.text = self.form.formTitle;
    self.formDescLabel.text = self.form.formDescription;
    self.formProjectLabel.text = [NSString stringWithFormat:@"Project: %@", self.form.project.projectTitle];
}

- (void)addNewFieldOfType:(FieldType *)type {
}

#pragma mark - EditingModeDesigning
- (BOOL)someFieldSelected {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected) {
        return YES;
    }
    return NO;
}

- (void)duplicateCurrentField {}

- (void)deleteCurrentField {
    if ([self someFieldSelected]) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        FormField *field = [self objectAtIndexPath:selected];
        [self.ffi deleteField:field completion:^(NSError *error) {
            if (error) {
                NSLog(@"💾 error %@", error);
            }
        }];
    }
}

#pragma mark - EditingMode Capturing Data
- (void)updateFieldAtIndex:(NSIndexPath *)indexPath withImage:(UIImage *)image {
    FormField *field = [self objectAtIndexPath:indexPath];
    if ([field isKindOfClass:[ImageField class]]) {
//        ((ImageField *)field).capturedImage = image;
        ImageFieldCell *imageCell = (ImageFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        imageCell.imageThumbnailView.image = image;
    }
}



#pragma mark - UITableViewDataSource methods
// Default is 1. No need to override.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self countItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FormField *item = (FormField *)[self objectAtIndexPath:indexPath];
    
    NSString *cellIdentifier = NSStringFromClass([item class]);
//    NSString *cellIdentifier = @"Cell";
    BaseFieldCell *cell = (BaseFieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.editingMode = self.editingMode;
    
    if ([item isKindOfClass:[TextField class]]) {
        
        TextField *field = (TextField *)item;
        TextFieldCell *cellT = (TextFieldCell *)cell;
        cellT.fieldTitle.text = field.fieldTitle;
        cellT.fieldDescription.text = field.fieldDescription;
        cellT.textField.text = field.capturedText;
        if (self.editingMode == FormEditingModeDesigning ||
            self.editingMode == FormEditingModePreview) {
            cellT.textField.userInteractionEnabled = NO;
        } else {
            cellT.textField.userInteractionEnabled = YES;
        }
        
    } else if ([item isKindOfClass:[ImageField class]]) {
        
        ImageField *field = (ImageField *)item;
        ImageFieldCell *cellI = (ImageFieldCell *)cell;
        cellI.fieldTitle.text = field.fieldTitle;
        cellI.fieldDescription.text = field.fieldDescription;
        cellI.imageThumbnailView.image = field.capturedImage;
        if (self.editingMode == FormEditingModeDesigning ||
            self.editingMode == FormEditingModePreview) {
            
            [cellI.imageAddButton setActionBlock:^{
                // Don't do anything;
            }];
        } else {
            __weak typeof(self) weakSelf = self;
            [cellI.imageAddButton setActionBlock:^{
                // Capture photo
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addPhotoButtonPressed:forFieldIndexPath:)]) {
                    [weakSelf.delegate addPhotoButtonPressed:cellI.imageAddButton forFieldIndexPath:indexPath];
                }
            }];
            
            //    __weak typeof(self) weakSelf = self;
            // OR
//            __weak typeof(self) weakSelf = self;
//            self.btnBlock.actionBlock = ^void (void) {
//                NSString *newText = [NSString stringWithFormat:@"Liked %@!", weakSelf.titleLabel.text];
//                weakSelf.titleLabel.text = newText;
//            };
        }
    }
    
    return cell;
}



#pragma mark Datasource helpers

- (void)configureCell:(UITableView *)cell atIndexPath:(NSIndexPath *)indexPath {
    
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
    self.activeFieldIndex = indexPath;
    FormField *item = (FormField *)[self objectAtIndexPath:indexPath];
    [self.delegate formManager:self didActivateField:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = tableView.rowHeight;
    FormField *item = (FormField *)[self objectAtIndexPath:indexPath];

    if ([item isKindOfClass:[TextField class]]) {
        
        result = 120.0;
        
    } else if ([item isKindOfClass:[ImageField class]]) {
        
        if (self.editingMode == FormEditingModeCapturingData) {
            result = 200.0;
        } else {
            result = 138.0;
        }
    }
    
    return result;
}


#pragma mark - Field properties UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Apply form changes to canvas controller.
    if (![self someFieldSelected]) {
        return;
    }
    
    FormField *activeField = (FormField *)[self objectAtIndexPath:self.activeFieldIndex];
    activeField.fieldTitle = textField.text;
    
//    [self.tableView selectRowAtIndexPath:self.activeFieldIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Field properties UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    // Apply form changes to canvas controller.
    if (![self someFieldSelected]) {
        return;
    }
    
    FormField *activeField = (FormField *)[self objectAtIndexPath:self.activeFieldIndex];
    activeField.fieldDescription = textView.text;
    
//    [self.tableView selectRowAtIndexPath:self.activeFieldIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}


@end
