//
//  FormsViewController.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormsViewController.h"
#import "ProjectCell.h"
#import "UIColor+FlatColors.h"
#import "ProjectDetailViewController.h"
#import "ListFormsInteractor.h"
#import "Project.h"
#import "FormDesignerViewController.h"

@interface FormsViewController ()<ProjectDetailVCDelegate>
@property (nonatomic, strong) ListFormsInteractor *lfi;
@end

@implementation FormsViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.collectionView.backgroundColor = [UIColor flatCloudsColor];
    }
    return self;
}

- (ListFormsInteractor *)lfi {
    if (!_lfi) {
        _lfi = [[ListFormsInteractor alloc] init];
    }
    return _lfi;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetchRequest = [self.lfi requestAllForProject:self.parentProject];
    self.managedObjectContext = self.lfi.defaultMOC;
    self.cellReusableIdentifier = reuseIdentifier;
    
    self.collectionView.alwaysBounceVertical = YES;
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"FormCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[ProjectCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openFormDesigner)];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(projectSettingsPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[addButton, settingsButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.parentProject) {
        self.navigationItem.title = self.parentProject.projectTitle;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)projectSettingsPressed:(id)sender {
    
    ProjectDetailViewController *editProjVC = (ProjectDetailViewController *)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"detailProjectIdentifier"];
    editProjVC.project = self.parentProject;
    editProjVC.delegate = self;
    editProjVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:editProjVC animated:YES completion:nil];
}

- (void)openFormDesigner {
    [self openFormDesignerWithForm:nil];
}

- (void)openFormDesignerWithForm:(Form *)form {
    
    UINavigationController *navVC = [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"formDesignerNavID"];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    if (form) {
        FormDesignerViewController *formVC = navVC.viewControllers[0];
        formVC.form = form;
    }
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
}

#pragma mark - Helpers
- (UIStoryboard *)mainStoryboard {
    UIStoryboard *mainStory = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] storyboard];
    if (!mainStory) {
        mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return mainStory;
}


#pragma mark - ProjectDetailVCDelegate
- (void)projectDetailVCDidUpdateTitle:(NSString *)newTitle {
    self.navigationItem.title = newTitle;
}

- (void)projectDetailVCDidDeleteProject {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Overrides
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    [super configureCell:cell atIndexPath:indexPath];
    
    ProjectCell *projCell = (ProjectCell *)cell;
    
    [projCell updateCellContentsWithItem:[self objectAtIndexPath:indexPath]];
}

#pragma mark <UICollectionViewDelegate>
- (void)  collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TEMP. Open form designer.
    Form *f = (Form *)[self objectAtIndexPath:indexPath];
    [self openFormDesignerWithForm:f];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(260, 110);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
