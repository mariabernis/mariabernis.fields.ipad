//
//  ProjectTCell.m
//  Fields
//
//  Created by Maria Bernis on 27/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectTCell.h"
#import "Project.h"
#import "UIColor+Fields.h"

@implementation ProjectTCell

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
    UIView * selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBGView.backgroundColor = [UIColor fieldsGreen];
    self.selectedBackgroundView = selectedBGView;
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.mainTitleLabel.textColor = [UIColor whiteColor];
    } else {
        self.mainTitleLabel.textColor = [UIColor fieldsGreen];
    }
}

- (void)updateCellContentsWithItem:(id)item
{
    if ([item isKindOfClass:[Project class]]) {
        Project *project = (Project *)item;
        self.mainTitleLabel.text = project.projectTitle;
        self.descriptionLabel.text = project.projectDescription;
        self.itemsInfoLabel.text = [NSString stringWithFormat:@"%lu forms", (unsigned long)project.forms.count];
        
        if (project.isTemplateContainer) {
            self.mainTitleLabel.textColor = [UIColor blueColor];
        } else {
            self.mainTitleLabel.textColor = [UIColor fieldsGreen];
        }
    }
}

@end
