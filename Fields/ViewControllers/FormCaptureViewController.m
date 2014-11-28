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

@interface FormCaptureViewController ()<FormCanvasManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) FormCanvasManager *formManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FormCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formManager = [[FormCanvasManager alloc] initWithTableView:self.tableView form:self.form editingMode:FormEditingModeCapturingData delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EditingModeCapturingData
- (void)addPhotoButtonPressed:(id)sender forField:(FormField *)field {
    
    // USE weakself!
    UIAlertController *alertController;
    UIAlertAction *cameraAction;
    UIAlertAction *galleryAction;
    
    alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    cameraAction = [UIAlertAction actionWithTitle:@"Capture from camera"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                              [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                                              
                                          }];
    
    galleryAction = [UIAlertAction actionWithTitle:@"Select existent"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               
                                               [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                               
                                           }];
    
    // note: you can control the order buttons are shown, unlike UIActionSheet
    [alertController addAction:cameraAction];
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

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.translucent=NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
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
        }
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
