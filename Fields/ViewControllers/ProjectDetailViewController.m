//
//  ProjectAddNewViewController.m
//  Fields
//
//  Created by Maria Bernis on 21/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectInteractor.h"

// This one does not need to conform to the transitioning delegate
@interface ProjectDetailViewController () 
@property (nonatomic, strong) ProjectInteractor *interactor;
// Outlets
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UITextView *inputDescription;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ProjectDetailViewController

- (ProjectInteractor *)interactor {
    if (!_interactor) {
        _interactor = [[ProjectInteractor alloc] initWithProject:self.project];
    }
    return _interactor;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.transitioningDelegate) {
        [self.inputTitle becomeFirstResponder];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)updateUI {
    if (self.project) {
        self.inputTitle.text = self.project.projectTitle;
        self.inputDescription.text = self.project.projectDescription ? : @"";
        self.navBar.topItem.title = @"Project details";
    }
    self.deleteButton.hidden = ![self.interactor canDeleteProject];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    // TO - DO Loaders.
    
    if (self.project == nil) {
        
        [self.interactor saveNewProjectWithTitle:self.inputTitle.text
                                  andDescription:self.inputDescription.text
                                      completion:^(BOOL success, NSError *error) {
                                          
                                          [self savingNewProjectDidFinishWithError:error];
        }];
        
    } else {
        
        [self.interactor updateProjectWithTitle:self.inputTitle.text
                                 andDescription:self.inputDescription.text
                                     completion:^(BOOL success, NSError *error) {
                                         
                                         [self updatingProjectDidFinishWithError:error];
        }];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self closeKeyBoardAndDismiss];
}

- (IBAction)deleteButtonPressed:(id)sender {
    
    [self.interactor deleteProject:^(BOOL success, NSError *error) {
        if (error) {
            [self handleDeletingError:error];
            return;
        }
        [self closeKeyBoardAndDismiss:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(projectDetailVCDidDeleteProject)]) {
                [self.delegate projectDetailVCDidDeleteProject];
            }
        }];
    }];
}

- (void)savingNewProjectDidFinishWithError:(NSError *)error {
    if (error) {
        [self handleCreatingNewError:error];
        return;
    }
    [self closeKeyBoardAndDismiss];
}

- (void)updatingProjectDidFinishWithError:(NSError *)error {
    if (error) {
        [self handleUpdatingError:error];
        return;
    }
    
    [self closeKeyBoardAndDismiss:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(projectDetailVCDidUpdateTitle:)]) {
            [self.delegate projectDetailVCDidUpdateTitle:self.project.projectTitle];
        }
    }];
}

- (void)handleCreatingNewError:(NSError *)error {
    
    if (!error) {
        return;
    }
    
    // TO-DO Display alert controller
    UIAlertController *alertVC =
    [UIAlertController alertControllerWithTitle:[error localizedDescription]
                                        message:[error localizedRecoverySuggestion]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    if (error.code == FLDErrorProjectTitleNil) {
        UIAlertAction *saveWithDefaults = [UIAlertAction actionWithTitle:@"Save with default title" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.interactor saveNewProjectWithDefaultTitleAndDescription:self.inputDescription.text
                                                               completion:^(BOOL success, NSError *error) {

                [self savingNewProjectDidFinishWithError:error];
            }];
        }];
        [alertVC addAction:saveWithDefaults];
    }
    
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)handleUpdatingError:(NSError *)error {
    if (!error) {
        return;
    }
    
    UIAlertController *alertVC =
    [UIAlertController alertControllerWithTitle:[error localizedDescription]
                                        message:[error localizedRecoverySuggestion]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    if (error.code == FLDErrorProjectTitleNil) {
        UIAlertAction *saveWithDefaults = [UIAlertAction actionWithTitle:@"Save with default title" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.interactor updateProjectWithDefaultTitleAndDescription:self.inputDescription.text
                                                              completion:^(BOOL success, NSError *error) {
                
                [self updatingProjectDidFinishWithError:error];
            }];
        }];
        [alertVC addAction:saveWithDefaults];
    }
    
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)handleDeletingError:(NSError *)error {
    if (!error) {
        return;
    }
    
    UIAlertController *alertVC =
    [UIAlertController alertControllerWithTitle:[error localizedDescription]
                                        message:[error localizedRecoverySuggestion]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)closeKeyBoardAndDismiss {
    [self closeKeyBoardAndDismiss:nil];
}

- (void)closeKeyBoardAndDismiss:(void(^)())completion {
    if ([self.inputTitle isFirstResponder]) {
        [self.inputTitle resignFirstResponder];
    }
    if ([self.inputDescription isFirstResponder]) {
        [self.inputDescription resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:completion];
}


@end
