//
//  ListFormsInteractor.m
//  Fields
//
//  Created by Maria Bernis on 23/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "ListFormsInteractor.h"
#import "Project.h"

@implementation ListFormsInteractor


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

#pragma PRIVATE
- (Project *)_createTemplatesProjectInContext:(NSManagedObjectContext *)context {
    Project *templatesProj = [Project MR_createInContext:context];
    templatesProj.projectTitle = TEMPLATES_PROJ_TITLE;
    templatesProj.projectDescription = TEMPLATES_PROJ_DESCRIPTION;
    [templatesProj setTemplatesContainerValue:YES];
    return templatesProj;
}


@end
