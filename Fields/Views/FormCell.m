//
//  ProjectCell.m
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormCell.h"
#import "FormMock.h"
#import "Project.h"
#import "Form.h"
#import "UIColor+Fields.h"
#import "UIColor+Fields.h"


@implementation FormCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
//    UIView * selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
//    selectedBGView.backgroundColor = [UIColor fieldsGreen];
//    self.selectedBackgroundView = selectedBGView;

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    
}

- (void)updateCellContentsWithItem:(id)item
{
    if ([item isKindOfClass:[Project class]]) {
        Project *project = (Project *)item;
        self.mainTitleLabel.text = project.projectTitle;
        self.descriptionLabel.text = project.projectDescription;
        self.itemsInfoLabel.text = [NSString stringWithFormat:@"%lu forms", (unsigned long)project.forms.count];
        
        if (project.isTemplateContainer) {
            self.backgroundColor = [UIColor fieldsLightGreen];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
        
    } else if ([item isKindOfClass:[Form class]]) {
        Form *form = (Form *)item;
        self.mainTitleLabel.text = form.formTitle;
        self.descriptionLabel.text = form.formDescription;
        
        
    }
}

@end
