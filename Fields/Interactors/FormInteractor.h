//
//  FormInteractor.h
//  Fields
//
//  Created by Maria Bernis on 24/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "BaseInteractor.h"
#import "Form.h"

@interface FormInteractor : BaseInteractor

- (instancetype)initWithForm:(Form *)aForm;

#pragma mark - Edit
- (void)updateFormWithTitle:(NSString *)titleTxt
                description:(NSString *)descriptionText
                    project:(Project *)project
                 completion:(void(^)(BOOL success, NSError *error))completionBlock;

#pragma mark - Delete
- (void)deleteForm:(void(^)(BOOL success, NSError *error))completionBlock;

#pragma mark - New
- (void)saveNewFormWithTitle:(NSString *)titleText
                 description:(NSString *)descriptionText
                     project:(Project *)project
                  completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (Form *)createNewFormInContext:(NSManagedObjectContext *)context
                       withTitle:(NSString *)titleText
                     description:(NSString *)descriptionText
                         project:(Project *)project;

#pragma - Checks
- (BOOL)canDeleteForm;
- (BOOL)isChangedTitle:(NSString *)title orDescription:(NSString *)description;


@end
