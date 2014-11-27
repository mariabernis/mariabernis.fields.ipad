//
//  FieldTypesListController.m
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FieldTypesListController.h"
#import "FieldTypeCell.h"
#import "FieldType.h"


@implementation FieldTypesListController 

- (NSArray *)data {
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FieldTypeCell";
    FieldTypeCell *cell = (FieldTypeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FieldType *item = [self.data objectAtIndex:indexPath.row];
    
    [self.delegate fieldTypesList:self configureCell:cell atIndexPath:indexPath withItem:item];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FieldTypeCell *cell = (FieldTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
    FieldType *selectedItem = [self.data objectAtIndex:indexPath.row];
    
    [self.delegate fieldTypesList:self didSelectCell:cell atIndexPath:indexPath withItem:selectedItem];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

@end
