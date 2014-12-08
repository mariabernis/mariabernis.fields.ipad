//
//  FieldTypesListController.h
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FieldTypesListController, FieldTypeCell, FieldType;
@protocol FieldTypesListControllerDelegate <NSObject>

@required
- (void)fieldTypesList:(FieldTypesListController *)controller configureCell:(FieldTypeCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(FieldType *)item;
- (void)fieldTypesList:(FieldTypesListController *)controller didSelectCell:(FieldTypeCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(FieldType *)item;

@optional

@end

@interface FieldTypesListController : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<FieldTypesListControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *data;

@end
