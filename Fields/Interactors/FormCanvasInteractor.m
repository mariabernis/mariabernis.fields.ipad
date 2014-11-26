//
//  FormCanvasInteractor.m
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "FormCanvasInteractor.h"
#import "Form.h"
#import "FormField.h"

@implementation FormCanvasInteractor


#pragma mark - Fields
- (NSFetchRequest *)requestAllFieldsForForm:(Form *)form {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", FormFieldRelationships.form, form];
    
    NSFetchRequest *request = [FormField MR_requestAllSortedBy:FormFieldAttributes.indexPathRow
                                                     ascending:YES
                                                 withPredicate:predicate
                                                     inContext:self.defaultMOC];
    
    return request;
    
}

@end
