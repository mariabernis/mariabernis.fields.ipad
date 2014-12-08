

#import <Foundation/Foundation.h>
#import "BaseInteractor.h"
#import "Project.h"


@interface ProjectInteractor : BaseInteractor

- (instancetype)initWithProject:(Project *)aProject;

#pragma mark - Edit 
- (void)updateProjectWithTitle:(NSString *)titleTxt
                andDescription:(NSString *)descriptionText
                    completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (void)updateProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
            completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (void)deleteProject:(void(^)(BOOL success, NSError *error))completionBlock;

- (BOOL)canDeleteProject;
- (BOOL)canEditProject;
- (BOOL)isChangedTitle:(NSString *)title orDescription:(NSString *)description;

#pragma mark - New
- (void)saveNewProjectWithTitle:(NSString *)titleTxt
                 andDescription:(NSString *)descriptionText
                     completion:(void(^)(BOOL success, NSError *error))completionBlock;

- (void)saveNewProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
            completion:(void(^)(BOOL success, NSError *error))completionBlock;
@end
