//
//  BCCBaseOptionsChooser.m
//  BCC Axa
//
//  Created by Maria Bernis on 28/01/14.
//  Copyright (c) 2014 flash2flash. All rights reserved.
//

#import "MBCBaseOptionsChooser.h"

@interface MBCBaseOptionsChooser ()
@property (assign, nonatomic) NSUInteger selectedIndex;
@end


@implementation MBCBaseOptionsChooser

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (void)configureIfPopover {
    //Calculate how tall the view should be by multiplying
    //the individual row height by the total number of rows.
    NSInteger rowsCount = [self.options count];
    NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                           heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger totalRowsHeight = rowsCount * 44;
    
//    //Calculate how wide the view should be by finding how
//    //wide each string is expected to be
//    CGFloat largestLabelWidth = 0;
//    for (NSString *colorName in _colorNames) {
//        //Checks size of text using the default font for UITableViewCell's textLabel.
//        CGSize labelSize = [colorName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
//        if (labelSize.width > largestLabelWidth) {
//            largestLabelWidth = labelSize.width;
//        }
//    }
//    
//    //Add a little padding to the width
//    CGFloat popoverWidth = largestLabelWidth + 100;
    
    //Set the property to tell the popover container how big this view will be.
    self.preferredContentSize = CGSizeMake(320, totalRowsHeight);
//    self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.selected != nil && self.options != nil)
    {
        self.selectedIndex = [self.options indexOfObject:self.selected];
    }
    if (self.navigationController) {
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureIfPopover];
    if (self.selected)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        
    }
}

- (void)dealloc{}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    if (self.selectedIndex != NSNotFound)
	{
        // Deselect previous selected cell
		UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        
        previousCell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    id selected = [self.options objectAtIndex:indexPath.row];
    
    self.selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    [self.delegate chooserController:self didSelectItem:selected];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.options != nil)
    {
        return [self.options count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == self.selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self.delegate chooserControllerConfigureCell:cell atIndexPath:indexPath];
    
    return cell;
}

@end
