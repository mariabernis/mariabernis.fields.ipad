//
//  BaseFieldCell.m
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "BaseFieldCell.h"
#import "UIColor+Fields.h"

@implementation BaseFieldCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    CALayer *contentLayer = self.contentView.layer;
    if (highlighted) {
        
        contentLayer.borderWidth = 3.0;
        contentLayer.borderColor = [UIColor colorWithHue:0.58 saturation:0.492 brightness:0.278 alpha:0.3].CGColor;
    } else {
        contentLayer.borderWidth = 0;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    CALayer *contentLayer = self.contentView.layer;
    if (selected) {
        
        contentLayer.borderWidth = 3.0;
        contentLayer.borderColor = [UIColor fieldsBlue].CGColor;
    } else {
        contentLayer.borderWidth = 0;
    }
}

- (CGFloat)preferredHeight {
    return 120.0;
}

@end
