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

@interface ProjectAddNewViewController () // This one does not need to conform to the transitioning delegate

@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UITextView *inputDescription;

@end

@implementation ProjectAddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Project *newProj = [Project MR_createInContext:localContext];
        newProj.projectTitle = self.inputTitle.text;
        newProj.projectDescription = self.inputDescription.text;
    } completion:^(BOOL success, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
