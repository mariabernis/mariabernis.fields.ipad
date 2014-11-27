//
//  FieldPropsTabView.m
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FieldPropsTabView.h"

@interface FieldPropsTabView ()

@property (weak, nonatomic) IBOutlet UIView *inactiveView;
@end


@implementation FieldPropsTabView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup {
    self.activeOptions = NO;
}

- (void)setActiveOptions:(BOOL)activeOptions {
    _activeOptions = activeOptions;
    self.inactiveView.hidden = activeOptions;
}

- (void)addDelegateForInputs:(id<UITextFieldDelegate, UITextViewDelegate>)inputsDelegate {
    
    if (!inputsDelegate) {
        return;
    }
    
    if (self.inputTitle.delegate) {
        [self.inputTitle setDelegate:nil];
    }
    
    if (self.inputDescription.delegate) {
        [self.inputDescription setDelegate:nil];
    }
    
    self.inputTitle.delegate = inputsDelegate;
    self.inputDescription.delegate = inputsDelegate;
}

@end
