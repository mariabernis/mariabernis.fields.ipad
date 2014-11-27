//
//  ListFormsInteractor.h
//  Fields
//
//  Created by Maria Bernis on 23/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "BaseInteractor.h"
#import "Form.h"

@interface ListFormsInteractor : BaseInteractor

#pragma mark - List
- (NSFetchRequest *)requestAllForProject:(Project *)project;

- (NSFetchRequest *)requestAllForProject:(Project *)project
                                sortedBy:(NSString *)sortTerm
                               ascending:(BOOL)ascending;

@end
