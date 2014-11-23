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
#import "Project.h"

@interface FormsViewController ()<ProjectDetailVCDelegate>

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


#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"FormCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[ProjectCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(projectSettingsPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[settingsButton];
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

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.collection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProjectCell *cell = (ProjectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell updateCellContentsWithItem:[self.collection objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)  collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TEMP. Open form designer.
    UINavigationController *navVC = [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"formDesignerNavID"];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
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
