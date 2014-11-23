//
//  BaseInteractor.h
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBCoreDataStack.h"

#define PROJECT_DEFAULT_TITLE      @"Fields Project"
#define TEMPLATES_PROJ_TITLE       @"Forms designs"
#define TEMPLATES_PROJ_DESCRIPTION @"Use this project to save forms you want to reuse in several projects. "

typedef enum {
    FLDErrorProjectTitleNil = 1,
    FLDErrorTemplatesProjCannotBeEdited = 2
}FLDError;

@interface BaseInteractor : NSObject
@property (nonatomic, strong) NSManagedObjectContext *defaultMOC;

/* Implement in subclass
- (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm
                              ascending:(BOOL)ascending;
*/

+ (NSError *)createFLDError:(FLDError)errorCode withTitleDescription:(NSString *)displayTitle additionalSuggestion:(NSString *)extentedTxt;

@end
