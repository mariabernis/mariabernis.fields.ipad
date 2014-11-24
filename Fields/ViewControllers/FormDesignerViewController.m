//
//  FormDesignerViewController.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormDesignerViewController.h"
#import "FormPropsTabView.h"
#import "FormInteractor.h"
#import "ProjectInteractor.h"

#define TAB_MARGIN 30.0

typedef enum {
    LateralPaneLEFT,
    LateralPaneRIGHT
} LateralPane;

@interface FormDesignerViewController ()

// Properties
@property (nonatomic, strong) FormInteractor *fi;
@property (nonatomic, strong) Project *selectedProject;

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
@property (weak, nonatomic) IBOutlet FormPropsTabView *formPropsTabView;


@end

@implementation FormDesignerViewController

- (FormInteractor *)fi {
    if (!_fi) {
        _fi = [[FormInteractor alloc] initWithForm:self.form];
    }
    return _fi;
}

- (void)setSelectedProject:(Project *)selectedProject {
    _selectedProject = selectedProject;
    if (self.formPropsTabView.subviews.count) {
        self.formPropsTabView.projChooserLabel.text = selectedProject.projectTitle;
    }
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Backg. notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResigneActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    // At load time both panes MUST be opened.
    self.lPaneOpened = YES;
    self.lPaneAnimating = NO;
    self.rPaneOpened = YES;
    self.rPaneAnimating = NO;
    self.lPaneCenterXOpen = self.leftPaneView.center.x;
    self.rPaneCenterXOpen = self.rightPaneView.center.x;
    
    // Load panes content views
    CGRect formTabRect = self.formPropsTabView.frame;
    [self.formPropsTabView removeFromSuperview];
    FormPropsTabView *realFormTab = (FormPropsTabView *)[[[NSBundle mainBundle] loadNibNamed:@"FormPropsTabView" owner:self options:nil] lastObject];
    [realFormTab setFrame:formTabRect];
    
    [self.rightPaneContent addSubview:realFormTab];
    self.formPropsTabView = realFormTab;
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

#pragma mark - Actions
- (void)updateUIWithFormData {
    self.selectedProject = self.form.project;
    // Update UI to form data
    self.navigationItem.title = self.form.formTitle;
    self.formPropsTabView.inputTitle.text = self.form.formTitle;
    self.formPropsTabView.inputDescription.text = self.form.formDescription ? : @"";
    
    if(self.isNewForm) {
        // Creating new form, persist data
        [self saveChanges:nil];
        
    }
}

- (IBAction)discardButtonPressed:(id)sender {

    [self deleteFormAction:sender];
    
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self saveChanges:^(NSError *error) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
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

- (void)deleteFormAction:(id)sender {
    
    UIAlertController *alertController;
    UIAlertAction *destroyAction;
    UIAlertAction *otherAction;
    
    alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    destroyAction = [UIAlertAction actionWithTitle:@"Remove All Data"
                                             style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *action) {
                                               // do destructive stuff here
                                               
                                               [self.fi deleteForm:^(BOOL success, NSError *error) {
                                                   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                               }];
                                               
                                           }];
    
    otherAction = [UIAlertAction actionWithTitle:@"Blah"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             // do something here
                                         }];
    // note: you can control the order buttons are shown, unlike UIActionSheet
    [alertController addAction:destroyAction];
    [alertController addAction:otherAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController
                                                     popoverPresentationController];
    
    if ([sender isKindOfClass:[UIView class]]) {
        popPresenter.sourceView = (UIView *)sender;
        popPresenter.sourceRect = ((UIView *)sender).bounds;
        
    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        popPresenter.barButtonItem = sender;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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

/*
- (void)lateralPaneWillStartShowing:(LateralPane)side {
    switch (side) {
        case LateralPaneLEFT:
            break;
            
        case LateralPaneRIGHT:
            break;
    }
}

- (void)lateralPaneWillStartHiding:(LateralPane)side {
    switch (side) {
        case LateralPaneLEFT:
            self.leftPaneAnimating = YES;
            break;
            
        case LateralPaneRIGHT:
            break;
    }
}
*/

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
    CGFloat offsetX = initialXCenter + offsetMultiplier * (CGRectGetWidth(view.frame) - TAB_MARGIN);
    CGFloat canvasNewX = 0;
    switch (side) {
        case LateralPaneLEFT: {
            if (isOpen) {
                canvasNewX = offsetX + view.center.x;
            } else {
                canvasNewX = CGRectGetWidth(view.frame);
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
                             
                             view.center = CGPointMake(offsetX,
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
