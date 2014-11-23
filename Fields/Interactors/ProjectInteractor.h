//
//  ProjectInteractor.h
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInteractor.h"
#import "Project.h"


@interface ProjectInteractor : BaseInteractor

- (instancetype)initWithProject:(Project *)aProject;

#pragma mark - Edit single project actions
- (void)updateProjectWithTitle:(NSString *)titleTxt
                andDescription:(NSString *)descriptionText
                    completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (void)updateProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
            completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (void)deleteProject:(void(^)(BOOL success, NSError *error))completionBlock;

- (BOOL)canDeleteProject;

#pragma mark - List
- (NSFetchRequest *)requestAllDefault;

- (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm
                             ascending:(BOOL)ascending;

#pragma mark - New
- (void)saveNewProjectWithTitle:(NSString *)titleTxt
                 andDescription:(NSString *)descriptionText
                     completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (void)saveNewProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
            completion:(void(^)(BOOL success, NSError *error))completionBlock;
@end
