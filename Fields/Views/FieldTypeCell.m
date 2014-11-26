//
//  FieldTypeCell.m
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FieldTypeCell.h"
#import "FieldType.h"

@implementation FieldTypeCell

- (void)setupWithFieldType:(FieldType *)type {
    self.typeNameLabel.text = type.typeName;
    self.typeDescriptionLabel.text = type.typeDescription;
    self.typeThumbnailView.image = type.typeThumbnail;
    
    [self.typeDescriptionLabel sizeToFit];
}

@end
