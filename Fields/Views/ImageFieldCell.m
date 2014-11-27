//
//  ImageFieldCell.m
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ImageFieldCell.h"

@implementation ImageFieldCell


- (void)commonSetup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferredHeight {
    return 138.0;
}

@end
