//
//  FieldTypeCell.h
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FieldType;
@interface FieldTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeThumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDescriptionLabel;

- (void)setupWithFieldType:(FieldType *)type;

@end
