//
//  BaseFieldCell.h
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormCanvasManager.h"

@interface BaseFieldCell : UITableViewCell

@property (nonatomic) FormEditingMode editingMode;

- (CGFloat)preferredHeight;
@end
