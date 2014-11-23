//
//  ProjectInteractor.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectInteractor.h"
#import "MBCheck.h"

@interface ProjectInteractor ()
@property (nonatomic, strong) Project *project;
@end

@implementation ProjectInteractor

- (instancetype)init
{
    return [self initWithProject:nil];
}

- (instancetype)initWithProject:(Project *)aProject
{
    self = [super init];
    if (self) {
        _project = aProject;
    }
    return self;
}

#pragma mark - Edit single project actions
- (void)updateProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
              completion:(void(^)(BOOL success, NSError *error))completionBlock {
    
    [self updateProjectWithTitle:PROJECT_DEFAULT_TITLE andDescription:descriptionText completion:completionBlock];
}

- (void)updateProjectWithTitle:(NSString *)titleTxt
                andDescription:(NSString *)descriptionText
                    completion:(void(^)(BOOL success, NSError *error))completionBlock {
    NSAssert(self.project != nil, @"Project is nil!");
    
    if (![self canEditProject]) {
        NSError *appError = [[self class] createFLDError:FLDErrorTemplatesProjCannotBeEdited];
        completionBlock(NO, appError);
        return;
    }
    
    if ([titleTxt mb_isEmpty]) { // If titleText is nil or empty string is not valid, so return an error.
        NSError *appError = [[self class] createFLDError:FLDErrorProjectTitleNil];
        
        completionBlock(NO, appError);
        return;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Project *localProj = [self.project MR_inContext:localContext];
        localProj.projectTitle = titleTxt;
        localProj.projectDescription = descriptionText;
        
    } completion:completionBlock];
}

- (void)deleteProject:(void(^)(BOOL success, NSError *error))completionBlock {
    NSAssert(self.project != nil, @"Project is nil!");
}

- (BOOL)canDeleteProject {
    if (!self.project) {
        return NO;
    }
    
    if ([self.project isTemplateContainer]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)canEditProject {
    if (!self.project) {
        return NO;
    }
    
    if ([self.project isTemplateContainer]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - New
- (void)saveNewProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
                     completion:(void(^)(BOOL success, NSError *error))completionBlock {

    [self saveNewProjectWithTitle:PROJECT_DEFAULT_TITLE andDescription:descriptionText completion:completionBlock];
}

- (void)saveNewProjectWithTitle:(NSString *)titleText
                andDescription:(NSString *)descriptionText
                    completion:(void(^)(BOOL success, NSError *error))completionBlock {
    
    if ([titleText mb_isEmpty]) { // If titleText is nil or empty string is not valid, so return an error.
        NSError *appError = [[self class] createFLDError:FLDErrorProjectTitleNil];
        
        completionBlock(NO, appError);
        
        return;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        [self _createNewProjectInContext:localContext withTitle:titleText andDescription:descriptionText];

    } completion:completionBlock];
    
    
    
    // TO-DO. Convert MR error or core data error to some understandable error. 
}

#pragma PRIVATE
- (Project *)_createNewProjectInContext:(NSManagedObjectContext *)context withTitle:(NSString *)titleText  andDescription:(NSString *)descriptionText {
    
    Project *newProj = [Project MR_createInContext:context];
    newProj.projectTitle = titleText;
    newProj.projectDescription = descriptionText;
    return newProj;
}

#pragma mark - Error messages
+ (NSError *)createFLDError:(FLDError)errorCode {
    
    NSString *displayTitle = nil;
    NSString *extendedTxt = nil;
    
    switch (errorCode) {
        case FLDErrorProjectTitleNil:
            displayTitle = @"Your project needs a name!";
            extendedTxt = @"If you don't set it, some default name will be used";
            break;
            
        case FLDErrorTemplatesProjCannotBeEdited:
            displayTitle = [NSString stringWithFormat:@"\"%@\" cannot be edited", TEMPLATES_PROJ_TITLE];
            break;
            
        default:
            break;
    }
    
    return [super createFLDError:errorCode withTitleDescription:displayTitle additionalSuggestion:extendedTxt];
}

@end
