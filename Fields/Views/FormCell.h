//
//  ProjectCell.h
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel *mainTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *itemsInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *quickActionButton;

- (void)updateCellContentsWithItem:(id)item;

@end
