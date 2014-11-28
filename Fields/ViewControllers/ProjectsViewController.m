//
//  MBCProjectsViewController.m
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectsViewController.h"
#import "UIColor+FlatColors.h"
#import "ProjectCell.h"
#import "ListProjectsInteractor.h"
#import "ProjectDetailViewController.h"
#import "MBCModalVCAnimator.h"
#import "FormsViewController.h"
#import "UIColor+Fields.h"

@interface ProjectsViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) ListProjectsInteractor *lpI;
@end


@implementation ProjectsViewController

static NSString * const reuseIdentifier = @"Cell";

- (ListProjectsInteractor *)lpI {
    if (!_lpI) {
        _lpI = [[ListProjectsInteractor alloc] init];
    }
    return _lpI;
}

#pragma mark - VC Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.fetchRequest) {
        self.fetchRequest = [self.lpI requestAllDefault];
        self.managedObjectContext = self.lpI.defaultMOC;
        self.cellReusableIdentifier = reuseIdentifier;
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    self.navigationItem.title = @"My Projects";
    self.collectionView.backgroundColor = [UIColor fieldsLightOcre];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddNewProjectView:)];
    
    self.navigationItem.rightBarButtonItems = @[addButton];
}

#pragma mark - Actions
- (void)openAddNewProjectView:(id)sender {
    
    UIViewController *addProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailProjectIdentifier"];
    addProjectVC.transitioningDelegate = self;
    addProjectVC.modalPresentationStyle = UIModalPresentationCustom; // OJO, PRESENTATION STYLE, no TRANSITION STYLE. FFFFF
    [self presentViewController:addProjectVC animated:YES completion:nil];
    
}


#pragma mark Overrides
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    
    ProjectCell *projCell = (ProjectCell *)cell;
    
    [projCell updateCellContentsWithItem:[self objectAtIndexPath:indexPath]];
}


#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    id item = [self.collection objectAtIndex:indexPath.row];
    if ([[self objectAtIndexPath:indexPath] isKindOfClass:[Project class]]) {
        // Push to forms view
        Project *p = (Project *)[self objectAtIndexPath:indexPath];
        FormsViewController *formsController = [[FormsViewController alloc] initWithProject:p]; // collectionLayout

        [self.navigationController pushViewController:formsController animated:YES];
    }
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
