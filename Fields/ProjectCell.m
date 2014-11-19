//
//  ProjectCell.m
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectCell.h"
#import "ProjectMock.h"
#import "FormMock.h"

@implementation ProjectCell

- (void)updateCellContentsWithItem:(id)item
{
    if ([item isKindOfClass:[ProjectMock class]]) {
        ProjectMock *project = (ProjectMock *)item;
        self.mainTitleLabel.text = project.projectTitle;
        self.descriptionLabel.text = project.projectDescription;
//        self.itemsInfoLabel.text = project
        
    } else if ([item isKindOfClass:[FormMock class]]) {
        FormMock *form = (FormMock *)item;
        self.mainTitleLabel.text = form.formTitle;
        self.descriptionLabel.text = form.formDescription;
        
        
    }
}

@end
