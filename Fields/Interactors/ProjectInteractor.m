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
    
    if ([MBCheck isEmpty:titleTxt]) { // If titleText is nil or empty string is not valid, so return an error.
        NSError *appError = [[self class] createFLDError:FLDErrorProjectTitleNil];
        
        completionBlock(NO, appError);
        return;
    }
    
    if (![self isChangedTitle:titleTxt orDescription:descriptionText]) {
        // Don't do anything
        completionBlock(YES, nil);
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Project *localProj = [self.project MR_inContext:localContext];
        localProj.projectTitle = titleTxt;
        localProj.projectDescription = descriptionText;
        localProj.dateModified = [NSDate date];
        
    } completion:completionBlock];
}

- (void)deleteProject:(void(^)(BOOL success, NSError *error))completionBlock {
    NSAssert(self.project != nil, @"Project is nil!");
    
    if (![self canDeleteProject]) {
        NSError *appError = nil;
        if ([self.project isTemplateContainer]) {
            appError = [[self class] createFLDError:FLDErrorTemplatesProjectCannotBeDeleted];
        } else {
            appError = [[self class] createFLDError:FLDErrorProjectCannotBeDeleted];
        }
        completionBlock(NO, appError);
        return;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Project *localProj = [self.project MR_inContext:localContext];
        [localProj MR_deleteEntity];
        
    } completion:completionBlock];
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

- (BOOL)isChangedTitle:(NSString *)title orDescription:(NSString *)description {
    
    BOOL titleChanged = YES;
    BOOL descChanged = YES;
    if ([[self.project.projectTitle mb_trimmedString] isEqualToString:[title mb_trimmedString]]) {
        titleChanged = NO;
    }
    
    if ([MBCheck isEmpty:self.project.projectDescription] && [MBCheck isEmpty:description]) {
        descChanged = NO;
    }
    
    if (![MBCheck isEmpty:self.project.projectDescription]) {
        if ([[self.project.projectDescription mb_trimmedString] isEqualToString:[description mb_trimmedString]]) {
            descChanged = NO;
        }
    }
    
    return (titleChanged || descChanged);
    
}

#pragma mark - New
- (void)saveNewProjectWithDefaultTitleAndDescription:(NSString *)descriptionText
                     completion:(void(^)(BOOL success, NSError *error))completionBlock {

    [self saveNewProjectWithTitle:PROJECT_DEFAULT_TITLE andDescription:descriptionText completion:completionBlock];
}

- (void)saveNewProjectWithTitle:(NSString *)titleText
                andDescription:(NSString *)descriptionText
                    completion:(void(^)(BOOL success, NSError *error))completionBlock {
    
    if ([MBCheck isEmpty:titleText]) { // If titleText is nil or empty string is not valid, so return an error.
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
            
        case FLDErrorTemplatesProjectCannotBeDeleted:
            displayTitle = [NSString stringWithFormat:@"\"%@\" cannot be deleted", TEMPLATES_PROJ_TITLE];;
            break;
            
        case FLDErrorProjectCannotBeDeleted:
            displayTitle = @"This project cannot be deleted";
            break;
            
        default:
            break;
    }
    
    return [super createFLDError:errorCode withTitleDescription:displayTitle additionalSuggestion:extendedTxt];
}

@end
