//
//  MockProvider.h
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MocksProvider : NSObject
+ (NSArray *)allProjects;
+ (NSArray *)allFormsWithProjectId:(NSString *)projectIdentifier;
+ (NSArray *)allRecordsWithFormId:(NSString *)formIdentifier;
@end
