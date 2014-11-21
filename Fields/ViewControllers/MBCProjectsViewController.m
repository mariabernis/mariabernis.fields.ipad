//
//  MBCProjectsViewController.m
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "MBCProjectsViewController.h"
#import "MocksProvider.h"
#import "ProjectCell.h"
#import "ProjectMock.h"
#import "Project.h"
#import "MBCoreDataStack.h"

@interface MBCProjectsViewController ()

@end


@implementation MBCProjectsViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetchRequest = [Project MR_requestAllSortedBy:ProjectAttributes.projectTitle ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]];
    self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;
    if (!self.collection) {
        self.collection = [MocksProvider allProjects];
        self.navigationItem.title = @"My Projects";
    }
    if (self.projectTitle) {
        self.navigationItem.title = self.projectTitle;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    
    ProjectCell *projCell = (ProjectCell *)cell;
    
    //    ProjectMock *p = [self.collection objectAtIndex:indexPath.row];
    //    UILabel *mainTitle = (UILabel *)[cell viewWithTag:100];
    //    mainTitle.text = p.projectTitle;
    
    [projCell updateCellContentsWithItem:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    projCell.backgroundColor = [UIColor whiteColor];
    UIView * selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor lightGrayColor];
    projCell.selectedBackgroundView = selectedBGView;
}

/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectCell *cell = (ProjectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
//    ProjectMock *p = [self.collection objectAtIndex:indexPath.row];
//    UILabel *mainTitle = (UILabel *)[cell viewWithTag:100];
//    mainTitle.text = p.projectTitle;
    
    [cell updateCellContentsWithItem:[self.collection objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    UIView * selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = selectedBGView;
    return cell;
}
*/
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.collection objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[ProjectMock class]]) {
        // Push to forms view
        ProjectMock *p = (ProjectMock *)item;
        MBCProjectsViewController *formsController = [self.storyboard instantiateViewControllerWithIdentifier:@"collectionLayout"]; // collectionLayout
        formsController.collection = [MocksProvider allFormsWithProjectId:p.projectIdentifier];
        formsController.projectTitle = p.projectTitle;
        [self.navigationController pushViewController:formsController animated:YES];
    }
}

@end
