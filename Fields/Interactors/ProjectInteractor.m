//
//  ProjectInteractor.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ProjectInteractor.h"
#import "MBCoreDataStack.h"
#import "MBCheck.h"

#define PROJECT_DEFAULT_TITLE      @"Fields Project"
#define TEMPLATES_PROJ_TITLE       @"Forms designs"
#define TEMPLATES_PROJ_DESCRIPTION @"Use this project to save forms you want to reuse in several projects. "



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
    
    // If titleText is nil or empty string is not valid, so return an error.
    if ([titleTxt mb_isEmpty]) {
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

#pragma mark - New
- (void)saveNewProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
                     completion:(void(^)(BOOL success, NSError *error))completionBlock {

    [self saveNewProjectWithTitle:PROJECT_DEFAULT_TITLE andDescription:descriptionText completion:completionBlock];
}

- (void)saveNewProjectWithTitle:(NSString *)titleText
                andDescription:(NSString *)descriptionText
                    completion:(void(^)(BOOL success, NSError *error))completionBlock {
    
    // If titleText is nil or empty string is not valid, so return an error.
    if ([titleText mb_isEmpty]) {
        NSError *appError = [[self class] createFLDError:FLDErrorProjectTitleNil];
        
        completionBlock(NO, appError);
        
        return;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        [self _createNewProjectInContext:localContext withTitle:titleText andDescription:descriptionText];

    } completion:completionBlock];
    // TO-DO. Convert MR error or core data error to some understandable error. 
}

- (Project *)_createNewProjectInContext:(NSManagedObjectContext *)context withTitle:(NSString *)titleText  andDescription:(NSString *)descriptionText {
    
    Project *newProj = [Project MR_createInContext:context];
    newProj.projectTitle = titleText;
    newProj.projectDescription = descriptionText;
    return newProj;
}

- (Project *)_createTemplatesProjectInContext:(NSManagedObjectContext *)context {
    Project *templatesProj = [Project MR_createInContext:context];
    templatesProj.projectTitle = TEMPLATES_PROJ_TITLE;
    templatesProj.projectDescription = TEMPLATES_PROJ_DESCRIPTION;
    [templatesProj setTemplatesContainerValue:YES];
    return templatesProj;
}

#pragma mark - List
- (NSFetchRequest *)requestAllDefault {
    
    return [self requestAllSortedBy:ProjectAttributes.projectTitle ascending:YES];
}

- (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm
                             ascending:(BOOL)ascending {
    
    NSUInteger count = [Project MR_countOfEntities];
    if (count != NSNotFound && count == 0) {
        // Create the templates projects
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            [self _createTemplatesProjectInContext:localContext];
        }];
    }
    
    
    NSFetchRequest *request = [Project MR_requestAllSortedBy:sortTerm ascending:ascending inContext:self.defaultMOC];
    
    return request;
}

@end
