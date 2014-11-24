//
//  FormDesignerViewController.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormDesignerViewController.h"

#define TAB_MARGIN 30.0

typedef enum {
    LateralPaneLEFT,
    LateralPaneRIGHT
} LateralPane;

@interface FormDesignerViewController ()

// Properties
@property (nonatomic, getter=isLPaneOpened) BOOL lPaneOpened;
@property (nonatomic, getter=isLPaneAnimating) BOOL lPaneAnimating;
@property (nonatomic, assign) CGFloat lPaneCenterXOpen;
@property (nonatomic, getter=isRPaneOpened) BOOL rPaneOpened;
@property (nonatomic, getter=isRPaneAnimating) BOOL rPaneAnimating;
@property (nonatomic, assign) CGFloat rPaneCenterXOpen;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *leftPaneView;
@property (weak, nonatomic) IBOutlet UIView *rightPaneView;
@property (weak, nonatomic) IBOutlet UIView *canvasView;

@end

@implementation FormDesignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // At load time both panes MUST be opened.
    self.lPaneOpened = YES;
    self.lPaneAnimating = NO;
    self.rPaneOpened = YES;
    self.rPaneAnimating = NO;
    self.lPaneCenterXOpen = self.leftPaneView.center.x;
    self.rPaneCenterXOpen = self.rightPaneView.center.x;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.form) {
        // Creating a new one
    }
}

#pragma mark - Actions
- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
