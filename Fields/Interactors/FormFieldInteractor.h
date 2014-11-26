//
//  FormFieldInteractor.h
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInteractor.h"

@class FieldType, Form, FormField;
@interface FormFieldInteractor : BaseInteractor

#pragma mark - New
- (void)saveNewFieldOfType:(FieldType *)type
           belongingToForm:(Form *)form
                completion:(void(^)(FormField *newFormField, NSError *error))completionBlock;

#pragma mark - Delete
- (void)deleteField:(FormField *)field completion:(void(^)(NSError *error))completionBlock;



@end
