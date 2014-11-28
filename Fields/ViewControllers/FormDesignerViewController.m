//
//  FormDesignerViewController.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormDesignerViewController.h"
#import "FormPropsTabView.h"
#import "FieldPropsTabView.h"
#import "FormInteractor.h"
#import "ListProjectsInteractor.h"
#import "MBCBaseOptionsChooser.h"
#import "FieldTypesListController.h"
#import "FieldTypesProvider.h"
#import "FieldTypeCell.h"
#import "FormCanvasManager.h"
#import "FormFieldInteractor.h"

#define TAB_MARGIN      30.0
#define PROPS_TAB_FIELD 0
#define PROPS_TAB_FORM  1

typedef enum {
    LateralPaneLEFT,
    LateralPaneRIGHT
} LateralPane;

@interface FormDesignerViewController ()<MBCBaseOptionsChooserDelegate, FieldTypesListControllerDelegate, FormCanvasManagerDelegate, UITextFieldDelegate, UITextViewDelegate>

// Properties
@property (nonatomic, strong) FormInteractor *fi;
@property (nonatomic, strong) Project *selectedProject;
@property (nonatomic, strong) ListProjectsInteractor *lpi;
@property (nonatomic, strong) NSArray *listProjects;
@property (nonatomic, strong) MBCBaseOptionsChooser *projectChooserVC;
@property (nonatomic, strong) UIPopoverController *projectChooserPopover;
@property (nonatomic, strong) FieldTypesProvider *fieldTypesProvider;
@property (nonatomic, strong) FieldTypesListController *fieldsTypesListController;
@property (nonatomic, strong) FormCanvasManager *formCanvasManager;
@property (nonatomic, strong) FormFieldInteractor *ffi;

@property (nonatomic, getter=isLPaneOpened) BOOL lPaneOpened;
@property (nonatomic, getter=isLPaneAnimating) BOOL lPaneAnimating;
@property (nonatomic, assign) CGFloat lPaneCenterXOpen;
@property (nonatomic, getter=isRPaneOpened) BOOL rPaneOpened;
@property (nonatomic, getter=isRPaneAnimating) BOOL rPaneAnimating;
@property (nonatomic, assign) CGFloat rPaneCenterXOpen;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *leftPaneView;
@property (weak, nonatomic) IBOutlet UIView *rightPaneView;
@property (weak, nonatomic) IBOutlet UIView *leftPaneContent;
@property (weak, nonatomic) IBOutlet UIView *rightPaneContent;
@property (weak, nonatomic) IBOutlet UIView *canvasView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *propsTab;
@property (weak, nonatomic) IBOutlet FormPropsTabView *formPropsTabView;
@property (weak, nonatomic) IBOutlet FieldPropsTabView *fieldPropsTabView;
@property (weak, nonatomic) IBOutlet UITableView *fieldTypesTableView;
@property (weak, nonatomic) IBOutlet UITableView *formCanvasTableView;

@end

@implementation FormDesignerViewController {
    BOOL _loading;
}

- (FormInteractor *)fi {
    if (!_fi) {
        _fi = [[FormInteractor alloc] initWithForm:self.form];
    }
    return _fi;
}

- (ListProjectsInteractor *)lpi {
    if (!_lpi) {
        _lpi = [[ListProjectsInteractor alloc] init];
    }
    return _lpi;
}

- (NSArray *)listProjects {
    if (!_listProjects) {
        _listProjects = [self.lpi allProjectsDefaultSort];
    }
    return _listProjects;
}

- (void)setSelectedProject:(Project *)selectedProject {
    _selectedProject = selectedProject;
    if (self.formPropsTabView.subviews.count) {
        self.formPropsTabView.projChooserLabel.text = selectedProject.projectTitle;
    }
}

- (FieldTypesProvider *)fieldTypesProvider {
    if (!_fieldTypesProvider) {
        _fieldTypesProvider = [[FieldTypesProvider alloc] init];
    }
    return _fieldTypesProvider;
}

- (FieldTypesListController *)fieldsTypesListController {
    if (!_fieldsTypesListController) {
        _fieldsTypesListController = [[FieldTypesListController alloc] init];
        _fieldsTypesListController.delegate = self;
    }
    return _fieldsTypesListController;
}

- (FormFieldInteractor *)ffi {
    if (!_ffi) {
        _ffi = [[FormFieldInteractor alloc] init];
    }
    return _ffi;
}


#pragma mark - VC life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _loading = YES;
    
    // Backg. notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResigneActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    // Load content
    [self.fieldTypesProvider loadFieldTypesWithCompletion:^(NSArray *fieldTypes, NSError *error) {
        if (!error) {
            self.fieldsTypesListController.data = fieldTypes;
            [self.fieldTypesTableView reloadData];
        }
    }];
    self.fieldTypesTableView.dataSource = self.fieldsTypesListController;
    self.fieldTypesTableView.delegate = self.fieldsTypesListController;
    
    self.formCanvasManager = [[FormCanvasManager alloc] initWithTableView:self.formCanvasTableView form:self.form editingMode:FormEditingModeDesigning delegate:self];
    
    // At load time both panes ARE open.
    self.lPaneOpened = YES;
    self.lPaneAnimating = NO;
    self.rPaneOpened = YES;
    self.rPaneAnimating = NO;
    self.lPaneCenterXOpen = self.leftPaneView.center.x;
    self.rPaneCenterXOpen = self.rightPaneView.center.x;
    
    // Load panes content views
    CGRect fieldTabRect = self.fieldPropsTabView.frame;
    [self.fieldPropsTabView removeFromSuperview];
    FieldPropsTabView *realFieldTab = (FieldPropsTabView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldPropsTabView" owner:self options:nil] lastObject];
    [realFieldTab setFrame:fieldTabRect];
    
    [self.rightPaneContent addSubview:realFieldTab];
    self.fieldPropsTabView = realFieldTab;
    [self.fieldPropsTabView addDelegateForInputs:self.formCanvasManager];
    
    
    CGRect formTabRect = self.formPropsTabView.frame;
    [self.formPropsTabView removeFromSuperview];
    FormPropsTabView *realFormTab = (FormPropsTabView *)[[[NSBundle mainBundle] loadNibNamed:@"FormPropsTabView" owner:self options:nil] lastObject];
    [realFormTab setFrame:formTabRect];
    
    [self.rightPaneContent addSubview:realFormTab];
    self.formPropsTabView = realFormTab;
    [self.formPropsTabView addDelegateForInputs:self];
    
    [self addTapsForFormPropertiesPane];
    [self addTapsForFieldPropertiesPane];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUIWithFormData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Finally
    if (_loading) {
        _loading = NO;
    }
}

#pragma mark - Actions
- (void)updateUIWithFormData {
    self.selectedProject = self.form.project;
    // Update UI to form data
//    self.navigationItem.title = self.form.formTitle;
    self.formPropsTabView.inputTitle.text = self.form.formTitle;
    self.formPropsTabView.inputDescription.text = self.form.formDescription ? : @"";
    
    if (_loading) {
        
        if (self.isNewForm) {
            [self.propsTab setSelectedSegmentIndex:PROPS_TAB_FORM];
            [self selectPropertiesTab:PROPS_TAB_FORM];
            
        } else {
            [self.propsTab setSelectedSegmentIndex:PROPS_TAB_FIELD];
            [self selectPropertiesTab:PROPS_TAB_FIELD];
            
            if (self.rPaneOpened) {
                [self closeLateralPane:LateralPaneRIGHT];
            }
        }
    }
}

- (void)addTapsForFormPropertiesPane {
    // Configure touches
    UITapGestureRecognizer *tapChooserGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnProjectsChooser:)];
    [self.formPropsTabView.projChooserView addGestureRecognizer:tapChooserGesture];
    
    UITapGestureRecognizer *tapDuplicateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnDuplicateForm:)];
    [self.formPropsTabView.actionDuplicateView addGestureRecognizer:tapDuplicateGesture];
    
    UITapGestureRecognizer *tapDeleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteFormAction:)];
    [self.formPropsTabView.actionDeleteView addGestureRecognizer:tapDeleteGesture];
}

- (void)addTapsForFieldPropertiesPane {
    UITapGestureRecognizer *tapDuplicateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnDuplicateField:)];
    [self.fieldPropsTabView.actionDuplicateView addGestureRecognizer:tapDuplicateGesture];
    
    UITapGestureRecognizer *tapDeleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnDeleteField:)];
    [self.fieldPropsTabView.actionDeleteView addGestureRecognizer:tapDeleteGesture];
}

- (void)appWillResigneActiveNotification:(NSNotification *)notification {
    [self saveChanges:nil];
}

- (void)saveChanges:(void(^)(NSError *error))completion {
    
    [self.fi updateFormWithTitle:self.formPropsTabView.inputTitle.text
                     description:self.formPropsTabView.inputDescription.text
                         project:self.selectedProject
                      completion:^(BOOL success, NSError *error) {
                          
                          if (completion) {
                              completion(error);
                          }
                      }];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self saveChanges:^(NSError *error) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)discardButtonPressed:(id)sender {
    
    [self deleteFormAction:sender];
    
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteFormAction:(id)sender {
    
    UIAlertController *alertController;
    UIAlertAction *destroyAction;
    //    UIAlertAction *otherAction;
    
    alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    destroyAction = [UIAlertAction actionWithTitle:@"Delete form"
                                             style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *action) {
                                               // do destructive stuff here
                                               
                                               [self.fi deleteForm:^(BOOL success, NSError *error) {
                                                   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                               }];
                                               
                                           }];
    
    // note: you can control the order buttons are shown, unlike UIActionSheet
    [alertController addAction:destroyAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController
                                                     popoverPresentationController];
    
    if ([sender isKindOfClass:[UIView class]]) {
        popPresenter.sourceView = (UIView *)sender;
        popPresenter.sourceRect = ((UIView *)sender).bounds;
        
    } else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
        popPresenter.sourceView = gesture.view;
        popPresenter.sourceRect = gesture.view.bounds;
        
    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        popPresenter.barButtonItem = sender;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)propsTabChanged:(UISegmentedControl *)sender {
    
    [self selectPropertiesTab:sender.selectedSegmentIndex];
}

- (void)selectPropertiesTab:(NSInteger)tab {
    switch (tab) {
        case PROPS_TAB_FIELD:
            self.fieldPropsTabView.hidden = NO;
            self.formPropsTabView.hidden = YES;
            break;
            
        case PROPS_TAB_FORM:
            self.fieldPropsTabView.hidden = YES;
            self.formPropsTabView.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - Field actions
- (void)tappedOnDuplicateField:(id)sender {
}

- (void)tappedOnDeleteField:(id)sender {
    [self.formCanvasManager deleteCurrentField];
}


#pragma mark - Form actions
- (void)tappedOnProjectsChooser:(UITapGestureRecognizer *)gesture {
    MBCBaseOptionsChooser *projectChooserVC = [[MBCBaseOptionsChooser alloc] initWithStyle:UITableViewStylePlain];
    projectChooserVC.delegate = self;
    projectChooserVC.options = self.listProjects;
    projectChooserVC.selected = self.selectedProject;
    
    if (self.projectChooserPopover == nil) {
        //The color picker popover is not showing. Show it.
        self.projectChooserPopover = [[UIPopoverController alloc] initWithContentViewController:projectChooserVC];
        [self.projectChooserPopover presentPopoverFromRect:self.formPropsTabView.projChooserView.bounds
                                                    inView:self.formPropsTabView.projChooserView
                                  permittedArrowDirections:UIPopoverArrowDirectionRight
                                                  animated:YES];
    } else {
        //The popover is showing. Hide it.
        [self.projectChooserPopover dismissPopoverAnimated:YES];
        self.projectChooserPopover = nil;
    }
    
}

- (void)tappedOnDuplicateForm:(UITapGestureRecognizer *)gesture {
}

#pragma mark MBCBaseOptionsChooserDelegate
- (void)chooserControllerConfigureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Project *p = (Project *) [self.listProjects objectAtIndex:indexPath.row];
    cell.textLabel.text = p.projectTitle;
}

- (void)chooserController:(MBCBaseOptionsChooser *)controller didSelectItem:(id)item {
    
    if ([item isMemberOfClass:[Project class]]) {
        self.selectedProject = item;
        self.form.project = item;
        [self.formCanvasManager updateFormHeader];
    }
    [self.projectChooserPopover dismissPopoverAnimated:YES];
    self.projectChooserPopover = nil;
}

#pragma mark - FieldTypesListControllerDelegate
- (void)fieldTypesList:(FieldTypesListController *)controller configureCell:(FieldTypeCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(FieldType *)item {
    
    [cell setupWithFieldType:item];
}

- (void)fieldTypesList:(FieldTypesListController *)controller didSelectCell:(FieldTypeCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(FieldType *)item {
    
//    // Create the image context
//    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
//    
//    // TO-DO add it to the form
//    // Thake the snapshot
//    [cell drawViewHierarchyInRect:self.view.frame afterScreenUpdates:NO];
//    // Get the snapshot
//    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    [self.formTableManager addItemsFromArray:@[snapshotImage]];
//    
//    // Clean
//    UIGraphicsEndImageContext();
    
//    UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
//    [self.formCanvasManager addItemsFromArray:@[snapshotView]];
    
    [self.ffi saveNewFieldOfType:item belongingToForm:self.form completion:^(FormField *newFormField, NSError *error) {
        
    }];
}

#pragma mark - FormCanvasManagerDelegate
- (void)formManager:(FormCanvasManager *)formManager didActivateField:(FormField *)field {
    self.fieldPropsTabView.activeOptions = YES;
    
    // Props drawing logic, depending on field selected.
    self.fieldPropsTabView.inputTitle.text = field.fieldTitle;
    self.fieldPropsTabView.inputDescription.text = field.fieldDescription;
    
    self.propsTab.selectedSegmentIndex = PROPS_TAB_FIELD;
    [self selectPropertiesTab:PROPS_TAB_FIELD];
    if (!self.rPaneOpened) {
        [self openLateralPane:LateralPaneRIGHT];
    }
}


#pragma mark - Form properties UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Apply form changes to canvas controller.
    if (textField == self.formPropsTabView.inputTitle) {
        self.form.formTitle = textField.text;
        [self.formCanvasManager updateFormHeader];
    }
}

#pragma mark - Form properties UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    // Apply form changes to canvas controller.
    if (textView == self.formPropsTabView.inputDescription) {
        self.form.formDescription = textView.text;
        [self.formCanvasManager updateFormHeader];
    }
}

#pragma mark - Panes

- (void)openLateralPane:(LateralPane)side {
    BOOL alreadyOpened = YES;
    switch (side) {
        case LateralPaneLEFT:
            alreadyOpened = self.lPaneOpened;
            break;
            
        case LateralPaneRIGHT:
            alreadyOpened = self.rPaneOpened;
            break;
    }
    
    if (!alreadyOpened) {
        [self animateLateralPane:side];
    }
}

- (void)closeLateralPane:(LateralPane)side {
    
    BOOL alreadyClosed = YES;
    switch (side) {
        case LateralPaneLEFT:
            alreadyClosed = !self.lPaneOpened;
            break;
            
        case LateralPaneRIGHT:
            alreadyClosed = !self.rPaneOpened;
            break;
    }
    
    if (!alreadyClosed) {
        [self animateLateralPane:side];
    }
}

- (IBAction)leftPaneTabDragged:(UIPanGestureRecognizer *)recognizer {
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    //    NSLog(@"✋ Gesture state: %d", recognizer.state);
    
    [self animateLateralPane:LateralPaneLEFT];
}

- (IBAction)rightPaneTabDragged:(UIPanGestureRecognizer *)recognizer {
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self animateLateralPane:LateralPaneRIGHT];
}

- (void)lateralPane:(LateralPane)side setAnimating:(BOOL)animating {
    switch (side) {
        case LateralPaneLEFT:
            self.lPaneAnimating = animating;
            break;
            
        case LateralPaneRIGHT:
            self.rPaneAnimating = animating;
            break;
    }
}

- (void)lateralPaneDidFinishedShowing:(LateralPane)side {
    [self lateralPane:side setAnimating:NO];
    switch (side) {
        case LateralPaneLEFT:
            self.lPaneOpened = YES;
            break;
            
        case LateralPaneRIGHT:
            self.rPaneOpened = YES;
            break;
    }
}

- (void)lateralPaneDidFinishedHiding:(LateralPane)side {
    
    [self lateralPane:side setAnimating:NO];
    switch (side) {
        case LateralPaneLEFT:
            self.lPaneOpened = NO;
            break;
            
        case LateralPaneRIGHT:
            self.rPaneOpened = NO;
            break;
    }
}


- (void)animateLateralPane:(LateralPane)side {
    
    UIView *view = nil;
    BOOL isAnimating = false;
    BOOL isOpen = false;
    NSInteger offsetMultiplier = 0;
    CGFloat initialXCenter = 0;
    switch (side) {
        case LateralPaneLEFT:
            view = self.leftPaneView;
            isAnimating = self.isLPaneAnimating;
            isOpen = self.isLPaneOpened;
            offsetMultiplier = -1;
            initialXCenter = self.lPaneCenterXOpen;
            break;
            
        case LateralPaneRIGHT:
            view = self.rightPaneView;
            isAnimating = self.isRPaneAnimating;
            isOpen = self.isRPaneOpened;
            offsetMultiplier = 1;
            initialXCenter = self.rPaneCenterXOpen;
            break;
    }
    
    
    if (isAnimating) {
        return;
    }
    
    // Maths
    CGFloat paneNewCenterX = initialXCenter + offsetMultiplier * (CGRectGetWidth(view.frame) - TAB_MARGIN);
    CGFloat canvasNewX = 0;
    UIView *paneContentView = view.subviews[1];
    switch (side) {
        case LateralPaneLEFT: {
            if (isOpen) {
                CGFloat paneNewOriginX = paneNewCenterX + offsetMultiplier * CGRectGetWidth(view.frame)/2;
                canvasNewX = paneNewOriginX + CGRectGetWidth(paneContentView.frame);
            } else {
                canvasNewX = CGRectGetWidth(paneContentView.frame);
            }

            break;
        }
        case LateralPaneRIGHT:
            canvasNewX = self.canvasView.frame.origin.x;
            break;
    }

    
    
    [self lateralPane:side setAnimating:YES];
    
    if (isOpen) {
        // Close it
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             view.center = CGPointMake(paneNewCenterX,
                                                       view.center.y);
                             self.canvasView.frame = CGRectMake(canvasNewX,
                                                                CGRectGetMinY(self.canvasView.frame),
                                                                CGRectGetWidth(self.canvasView.frame) + (CGRectGetWidth(view.frame) - TAB_MARGIN),
                                                                CGRectGetHeight(self.canvasView.frame));
                             
                         } completion:^(BOOL finished) {
                             [self lateralPaneDidFinishedHiding:side];
                         }];
        
    } else {
        // Open it
        [UIView animateWithDuration:0.3
                         animations:^{
                             view.center = CGPointMake(initialXCenter,
                                                       view.center.y);
                             self.canvasView.frame = CGRectMake(canvasNewX,
                                                                CGRectGetMinY(self.canvasView.frame),
                                                                CGRectGetWidth(self.canvasView.frame) - (CGRectGetWidth(view.frame) - TAB_MARGIN),
                                                                CGRectGetHeight(self.canvasView.frame));
                             
                         } completion:^(BOOL finished) {
                             [self lateralPaneDidFinishedShowing:side];
                         }];
    }
}



@end
