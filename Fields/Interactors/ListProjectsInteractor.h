//
//  ListProjectsInteractor.h
//  Fields
//
//  Created by Maria Bernis on 23/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInteractor.h"
#import "Project.h"

@interface ListProjectsInteractor : BaseInteractor

#pragma mark - List
- (NSFetchRequest *)requestAllDefault;

- (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm
                             ascending:(BOOL)ascending;

- (NSArray *)allProjectsDefaultSort;

@end
