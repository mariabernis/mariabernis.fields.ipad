//
//  ImageFieldCell.h
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFieldCell.h"

@interface ImageFieldCell : BaseFieldCell

@property (weak, nonatomic) IBOutlet UILabel *fieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *fieldDescription;
@property (weak, nonatomic) IBOutlet UIButton *imageAddButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnailView;


@end
