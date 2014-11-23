//
//  ProjectAddNewViewController.h
//  Fields
//
//  Created by Maria Bernis on 21/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectDetailViewController;
@protocol ProjectDetailVCDelegate <NSObject>
@required

@optional
- (void)projectDetailVCDidUpdateTitle:(NSString *)newTitle;
- (void)projectDetailVCDidDeleteProject;
@end

@class Project;
@interface ProjectDetailViewController : UIViewController
@property (nonatomic, strong) Project *project;
@property (nonatomic, weak) id<ProjectDetailVCDelegate> delegate;
@end
