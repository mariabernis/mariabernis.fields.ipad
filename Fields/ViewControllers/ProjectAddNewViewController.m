//
//  ProjectAddNewViewController.m
//  Fields
//
//  Created by Maria Bernis on 21/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectAddNewViewController.h"
#import "Project.h"
#import "MBCoreDataStack.h"

// This one does not need to conform to the transitioning delegate
@interface ProjectAddNewViewController () 

@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UITextView *inputDescription;

@end

@implementation ProjectAddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.inputTitle becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.inputTitle becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (IBAction)saveButtonPressed:(id)sender {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Project *newProj = [Project MR_createInContext:localContext];
        newProj.projectTitle = self.inputTitle.text;
        newProj.projectDescription = self.inputDescription.text;
        
    } completion:^(BOOL success, NSError *error) {
        
        [self closeKeyBoardAndDismiss];
    }];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self closeKeyBoardAndDismiss];
}

- (void)closeKeyBoardAndDismiss {
    if ([self.inputTitle isFirstResponder]) {
        [self.inputTitle resignFirstResponder];
    }
    if ([self.inputDescription isFirstResponder]) {
        [self.inputDescription resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
