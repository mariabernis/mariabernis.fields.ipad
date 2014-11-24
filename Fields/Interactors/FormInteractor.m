//
//  FormInteractor.m
//  Fields
//
//  Created by Maria Bernis on 24/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormInteractor.h"
#import "Project.h"
#import "MBCheck.h"


@interface FormInteractor ()
@property (nonatomic, strong) Form *form;
@end


@implementation FormInteractor

- (instancetype)init
{
    return [self initWithForm:nil];
}

- (instancetype)initWithForm:(Form *)aForm
{
    self = [super init];
    if (self) {
        _form = aForm;
    }
    return self;
}

#pragma mark - Edit
- (void)updateFormWithTitle:(NSString *)titleTxt
                description:(NSString *)descriptionText
                    project:(Project *)project
                 completion:(void(^)(BOOL success, NSError *error))completionBlock {
    NSAssert(self.form != nil, @"Form is nil!");
    
    // SAVE NO MATTER WHAT
//    if (![self isChangedTitle:titleTxt orDescription:descriptionText] &&
//        [self.form.project isEqual:project]) {
//        // Don't do anything
//        completionBlock(YES, nil);
//        return;
//    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Form *local = [self.form MR_inContext:localContext];
        if (![MBCheck isEmpty:titleTxt]) {
            local.formTitle = titleTxt;
        }
        local.formDescription = descriptionText;
        if (![self.form.project isEqual:project]) {
            [self.form customSetProject:project];
        }
        local.dateModified = [NSDate date];
        
    } completion:completionBlock];
}

#pragma mark - Delete
- (void)deleteForm:(void(^)(BOOL success, NSError *error))completionBlock {
    NSAssert(self.form != nil, @"Form is nil!");
    
    /* No aplica por ahora
    if (![self canDeleteForm]) {
        NSError *appError = appError = [[self class] createFLDError:FLDErrorTemplatesProjectCannotBeDeleted];;
        completionBlock(NO, appError);
        return;
    }
    */
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Form *local = [self.form MR_inContext:localContext];
        [local MR_deleteEntity];
        
    } completion:completionBlock];
}

#pragma mark - New
- (void)saveNewFormWithTitle:(NSString *)titleText
                 description:(NSString *)descriptionText
                     project:(Project *)project
                  completion:(void(^)(BOOL success, NSError *error))completionBlock {
    NSAssert(project != nil, @"Project cannot be nil. Fom MUST have a project!");
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        [self createNewFormInContext:localContext withTitle:titleText description:descriptionText project:project];
        
    } completion:completionBlock];
    
    
    // TO-DO. Convert MR error or core data error to some understandable error.
}

#pragma create in memory
- (Form *)createNewFormInContext:(NSManagedObjectContext *)context
                       withTitle:(NSString *)titleText
                     description:(NSString *)descriptionText
                         project:(Project *)project {
    
    Form *newForm = [Form MR_createInContext:context];
    if (![MBCheck isEmpty:titleText]) {
        newForm.formTitle = titleText;
    }
    newForm.formDescription = descriptionText;
    if (project) {
        [newForm customSetProject:project];
    }
    return newForm;
}

#pragma mark - Duplicate



#pragma - Checks
- (BOOL)canDeleteForm {
    if (!self.form) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isChangedTitle:(NSString *)title orDescription:(NSString *)description {
    
    BOOL titleChanged = YES;
    BOOL descChanged = YES;
    if ([[self.form.formTitle mb_trimmedString] isEqualToString:[title mb_trimmedString]]) {
        titleChanged = NO;
    }
    
    if ([MBCheck isEmpty:self.form.formDescription] && [MBCheck isEmpty:description]) {
        descChanged = NO;
    }
    
    if (![MBCheck isEmpty:self.form.formDescription]) {
        if ([[self.form.formDescription mb_trimmedString] isEqualToString:[description mb_trimmedString]]) {
            descChanged = NO;
        }
    }
    
    return (titleChanged || descChanged);
    
}


// TO-DO this belong to another interactor. The formdesignInteractor or something like this.
- (BOOL)canEditFormDesign {
    // Si tiene reports no se puede editar. Se puede hacer una copia y editar la copia.
    // Las properties generales siempre se pueden cambiar: titulo, desc, project
    return YES;
}

#pragma mark - Error messages
+ (NSError *)createFLDError:(FLDError)errorCode {
    
    NSString *displayTitle = nil;
    NSString *extendedTxt = nil;
    
    switch (errorCode) {
        case FLDErrorProjectTitleNil:
//            displayTitle = @"Your project needs a name!";
//            extendedTxt = @"If you don't set it, some default name will be used";
            break;
            
        default:
            break;
    }
    
    return [super createFLDError:errorCode withTitleDescription:displayTitle additionalSuggestion:extendedTxt];
}

@end
