//
//  ProjectsMasterViewController.m
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectsMasterViewController.h"
#import "ListProjectsInteractor.h"
#import "ProjectCell.h"
#import "FormsViewController.h"
#import "MBCModalVCAnimator.h"

@interface ProjectsMasterViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) ListProjectsInteractor *lpI;
@end

@implementation ProjectsMasterViewController

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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddNewProjectView:)];
    
    self.navigationItem.leftBarButtonItems = @[addButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openAddNewProjectView:(id)sender {
    
    UIViewController *addProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailProjectIdentifier"];
    addProjectVC.transitioningDelegate = self;
    addProjectVC.modalPresentationStyle = UIModalPresentationCustom; // OJO, PRESENTATION STYLE, no TRANSITION STYLE. FFFFF
    [self presentViewController:addProjectVC animated:YES completion:nil];
    
}

#pragma mark Overrides
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    
    ProjectCell *projCell = (ProjectCell *)cell;
    [projCell updateCellContentsWithItem:[self objectAtIndexPath:indexPath]];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Project *p = (Project *)[self objectAtIndexPath:indexPath];
        FormsViewController *formsController = (FormsViewController *)[[segue destinationViewController] topViewController];
        formsController.parentProject = p;
        
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        formsController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        formsController.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table view delegate
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
