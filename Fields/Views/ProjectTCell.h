//
//  ProjectTCell.h
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *mainTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *itemsInfoLabel;

- (void)updateCellContentsWithItem:(id)item;

@end
