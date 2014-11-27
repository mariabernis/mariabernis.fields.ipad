//
//  FieldPropsTabView.m
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FieldPropsTabView.h"

@implementation FieldPropsTabView

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
