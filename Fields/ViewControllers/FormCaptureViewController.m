//
//  FormCaptureViewController.m
//  Fields
//
//  Created by Maria Bernis on 28/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormCaptureViewController.h"
#import "FormCanvasManager.h"
#import "FormInteractor.h"
#import "UIColor+Fields.h"

@interface FormCaptureViewController ()<FormCanvasManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) FormCanvasManager *formManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *fieldIndexWaitingForPhoto;
@end

@implementation FormCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formManager = [[FormCanvasManager alloc] initWithTableView:self.tableView form:self.form editingMode:FormEditingModeCapturingData delegate:self];
    self.view.backgroundColor = [UIColor fieldsLightOcre];
    
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonPressed:)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed:)];
    self.navigationItem.leftBarButtonItems = @[closeBarBtn];
    self.navigationItem.rightBarButtonItems = @[doneBtn, shareBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareButtonPressed:(id)sender {
}

#pragma mark - EditingModeCapturingData
- (void)addPhotoButtonPressed:(id)sender forFieldIndexPath:(NSIndexPath *)indexPath {
    
    // USE weakself!
    UIAlertController *alertController;
    UIAlertAction *cameraAction;
    UIAlertAction *galleryAction;
    UIView *senderV = (UIView *)sender;
    
    alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];

    cameraAction = [UIAlertAction actionWithTitle:@"Add photo using camera"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              self.fieldIndexWaitingForPhoto = indexPath;
                                              [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera fromView:senderV];
                                              
                                          }];
    
    galleryAction = [UIAlertAction actionWithTitle:@"Add photo selecting existent"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               self.fieldIndexWaitingForPhoto = indexPath;
                                               [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary fromView:senderV];
                                               
                                           }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:galleryAction];
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

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType fromView:(UIView *)view {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.translucent=NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
//    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage* selectedImage = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
        if (selectedImage != nil) {
            
            // Si venimos de la camara...
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                // ...Guardamos la foto en el album
                UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
            }
            [self.formManager updateFieldAtIndex:self.fieldIndexWaitingForPhoto withImage:selectedImage];
            self.fieldIndexWaitingForPhoto = nil;
        }
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.fieldIndexWaitingForPhoto = nil;
}

#pragma mark - Popover controller delegate
- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return NO;
}

@end
