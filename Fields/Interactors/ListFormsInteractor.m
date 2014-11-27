//
//  ListFormsInteractor.m
//  Fields
//
//  Created by Maria Bernis on 23/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ListFormsInteractor.h"

@class Project;
@implementation ListFormsInteractor


#pragma mark - List
- (NSFetchRequest *)requestAllForProject:(Project *)project {
    
    return [self requestAllForProject:project sortedBy:FormAttributes.dateCreated ascending:YES];
}

- (NSFetchRequest *)requestAllForProject:(Project *)project
                                sortedBy:(NSString *)sortTerm
                               ascending:(BOOL)ascending {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", FormRelationships.project, project];
    NSFetchRequest *request = [Form MR_requestAllSortedBy:sortTerm ascending:ascending withPredicate:predicate inContext:self.defaultMOC];
    
//    NSFetchRequest *request = [Form MR_requestAllSortedBy:sortTerm ascending:ascending inContext:self.defaultMOC];
    
    return request;
}


@end
