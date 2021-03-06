//
//  FormsViewController.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormsViewController.h"
#import "FormCell.h"
#import "UIColor+FlatColors.h"
#import "ProjectDetailViewController.h"
#import "ListFormsInteractor.h"
#import "FormInteractor.h"
#import "Project.h"
#import "FormDesignerViewController.h"
#import "UIColor+Fields.h"
#import "MBCModalVCAnimator.h"
#import "UIButton+Block.h"
#import "FormCaptureViewController.h"


@interface FormsViewController ()<ProjectDetailVCDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) ListFormsInteractor *lfi;
@property (nonatomic, strong) FormInteractor *fi;
@end

@implementation FormsViewController

static NSString * const reuseIdentifier = @"Cell";

/* Designated initializer */
- (instancetype)initWithProject:(Project *)project {
    
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {
        _parentProject = project;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    return [self initWithProject:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
}

- (ListFormsInteractor *)lfi {
    if (!_lfi) {
        _lfi = [[ListFormsInteractor alloc] init];
    }
    return _lfi;
}

- (FormInteractor *)fi {
    if (!_fi) {
        _fi = [[FormInteractor alloc] init];
    }
    return _fi;
}

#pragma mark - VC life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetchRequest = [self.lfi requestAllForProject:self.parentProject];
    self.managedObjectContext = self.lfi.defaultMOC;
    self.cellReusableIdentifier = reuseIdentifier;
    
    self.collectionView.backgroundColor = [UIColor fieldsLightOcre];
    self.collectionView.alwaysBounceVertical = YES;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"FormCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[ProjectCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIButton *fieldsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fieldsButton.frame = CGRectMake(0, 0, 40, 30);
    [fieldsButton setImage:[UIImage imageNamed:@"rastrillo_xsmall"] forState:UIControlStateNormal];
    fieldsButton.backgroundColor = [UIColor fieldsGreen];
    fieldsButton.layer.cornerRadius = 3;
    [fieldsButton addTarget:self action:@selector(newFormForCurrentProject) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fieldsBarButton = [[UIBarButtonItem alloc] initWithCustomView:fieldsButton];

    
    UIButton *projectInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    projectInfoButton.frame = CGRectMake(0, 0, 150, 30);
    [projectInfoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [projectInfoButton setTitleColor:[UIColor fieldsGreen] forState:UIControlStateNormal];
    [projectInfoButton setImage:[UIImage imageNamed:@"basic_info"] forState:UIControlStateNormal];
    [projectInfoButton setTitle:@"  Project info" forState:UIControlStateNormal];
    [projectInfoButton addTarget:self action:@selector(projectSettingsPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *projectInfoBarBtn = [[UIBarButtonItem alloc] initWithCustomView:projectInfoButton];
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(projectSettingsPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[fieldsBarButton, projectInfoBarBtn];
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
    editProjVC.transitioningDelegate = self;
    editProjVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:editProjVC animated:YES completion:nil];
}

- (void)newFormForCurrentProject {
    // Create form and pass it to the form builder.
    [self.fi saveNewFormWithTitle:nil
                      description:nil
                          project:self.parentProject
                       completion:^(Form *newForm, NSError *error) {
                           
        [self openFormDesignerWithForm:newForm isNewForm:YES];
    }];
}

- (void)openFormDesignerWithForm:(Form *)form {
    [self openFormDesignerWithForm:form isNewForm:NO];
}

- (void)openFormDesignerWithForm:(Form *)form isNewForm:(BOOL)isNew {
    
    UINavigationController *navVC = [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"formDesignerNavID"];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    FormDesignerViewController *formVC = navVC.viewControllers[0];
    formVC.form = form;
    formVC.isNewForm = isNew;
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
    
    FormCell *formCell = (FormCell *)cell;
    [formCell updateCellContentsWithItem:[self objectAtIndexPath:indexPath]];
    
    __weak typeof(self) weakSelf = self;
    [formCell.quickActionButton setActionBlock:^{
        Form *f = (Form *)[weakSelf objectAtIndexPath:indexPath];
        [weakSelf openFormDesignerWithForm:f];
    }];
}

#pragma mark <UICollectionViewDelegate>
- (void)  collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TEMP. Open form designer.
//    [self openFormDesignerWithForm:f];
    Form *f = (Form *)[self objectAtIndexPath:indexPath];
    UINavigationController *navVC = [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"formCapturerNavID"];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    FormCaptureViewController *formVC = navVC.viewControllers[0];
    formVC.form = f;
    
    [self presentViewController:navVC animated:YES completion:nil];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 90);
}


#pragma mark - UIViewControllerTransitioningDelegate protocol methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    MBCModalVCAnimator *animator = [MBCModalVCAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    MBCModalVCAnimator *animator = [MBCModalVCAnimator new];
    animator.presenting = NO;
    return animator;
}

@end
