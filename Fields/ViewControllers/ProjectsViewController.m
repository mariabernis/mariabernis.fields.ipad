//
//  MBCProjectsViewController.m
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectsViewController.h"
#import "MocksProvider.h"
#import "ProjectCell.h"
#import "ProjectMock.h"
#import "Project.h"
#import "MBCoreDataStack.h"
#import "ProjectAddNewViewController.h"
#import "MBCModalVCAnimator.h"
#import "FormsViewController.h"

@interface ProjectsViewController () <UIViewControllerTransitioningDelegate>

@end


@implementation ProjectsViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.fetchRequest) {
        self.fetchRequest = [Project MR_requestAllSortedBy:ProjectAttributes.projectTitle ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]];
        self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
        self.cellReusableIdentifier = reuseIdentifier;
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    self.navigationItem.title = @"My Projects";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddNewProjectView:)];
    
    self.navigationItem.rightBarButtonItems = @[addButton];
}

#pragma mark - Actions
- (void)openAddNewProjectView:(id)sender {
    
    UIViewController *addProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addProjectIdentifier"];
    addProjectVC.transitioningDelegate = self;
    addProjectVC.modalPresentationStyle = UIModalPresentationCustom; // OJO, PRESENTATION STYLE, no TRANSITION STYLE. FFFFF
    [self presentViewController:addProjectVC animated:YES completion:nil];
    
}


#pragma mark <UICollectionViewDataSource>
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    
    ProjectCell *projCell = (ProjectCell *)cell;
    
    [projCell updateCellContentsWithItem:[self objectAtIndexPath:indexPath]];
    projCell.backgroundColor = [UIColor whiteColor];
    UIView * selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor lightGrayColor];
    projCell.selectedBackgroundView = selectedBGView;
}


#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    id item = [self.collection objectAtIndex:indexPath.row];
    if ([[self objectAtIndexPath:indexPath] isKindOfClass:[Project class]]) {
        // Push to forms view
        Project *p = (Project *)[self objectAtIndexPath:indexPath];
        FormsViewController *formsController = [[FormsViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]; // collectionLayout
        formsController.collection = [MocksProvider allFormsWithProjectId:@"someIdentifier"];
        formsController.projectTitle = p.projectTitle;
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