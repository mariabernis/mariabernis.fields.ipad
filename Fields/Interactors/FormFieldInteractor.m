//
//  FormFieldInteractor.m
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormFieldInteractor.h"
#import "FieldType.h"
#import "Form.h"


@interface FormFieldInteractor ()

@end


@implementation FormFieldInteractor

#pragma mark - New
- (void)saveNewFieldOfType:(FieldType *)type
           belongingToForm:(Form *)form
                completion:(void(^)(FormField *newFormField, NSError *error))completionBlock {
    
    __block FormField *newField = [self newFormFieldInContext:self.defaultMOC ofType:type belongingToForm:form];
    
    [self.defaultMOC MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            [newField MR_deleteEntity];
            newField = nil;
        }
        completionBlock(newField, error);
    }];
    
}

- (FormField *)newFormFieldInContext:(NSManagedObjectContext *)context
                              ofType:(FieldType *)type
                     belongingToForm:(Form *)form {
    
    FormField *field = (FormField *)[NSEntityDescription insertNewObjectForEntityForName:type.typeIdentifier inManagedObjectContext:context];
    field.form = form;
    field.fieldTitle = @"Field title";
    field.fieldDescription = @"Description";
    NSUInteger count = form.fields.count;
    field.indexPathRow = @(count);
    
    return field;
}


#pragma mark - Delete
- (void)deleteField:(FormField *)field completion:(void(^)(NSError *error))completionBlock {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        FormField *localField = (FormField *)[localContext objectWithID:field.objectID];
        [localField MR_deleteEntity];
        
    } completion:^(BOOL success, NSError *error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

@end
