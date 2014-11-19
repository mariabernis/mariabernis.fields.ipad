//
//  MockProvider.m
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "MocksProvider.h"
#import "ProjectMock.h"
#import "FormMock.h"
#import "ReportMock.h"

@implementation MocksProvider

+ (NSArray *)allProjects
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        ProjectMock *s = [[ProjectMock alloc] init];
        int n = i+1;
        s.projectIdentifier = [NSString stringWithFormat:@"%i", n];
        s.projectTitle = [NSString stringWithFormat:@"Project Title %d", n];
        s.projectDescription = @"Overview Lorem ipsum dolor sit er elit lamet. ";
        
        [array addObject:s];
    }
    
    return [array copy];
}



+ (NSArray *)allFormsWithProjectId:(NSString *)projectIdentifier
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        FormMock *s = [[FormMock alloc] init];
        int n = i+1;
        s.formIdentifier = [NSString stringWithFormat:@"%i", n];
        s.formTitle = [NSString stringWithFormat:@"Form Title %d", n];
        s.formDescription = @"Overview Lorem ipsum dolor sit er elit lamet. ";
        s.projectIdentifier = projectIdentifier;
        
        [array addObject:s];
    }
    
    return [array copy];
}


+ (NSArray *)allRecordsWithFormId:(NSString *)formIdentifier
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        ReportMock *s = [[ReportMock alloc] init];
        int n = i+1;
        s.reportIdentifier = [NSString stringWithFormat:@"%i", n];
        s.reportValue1 = @"Overview Lorem ipsum dolor sit er elit lamet. ";
        s.formIdentifier = formIdentifier;
        [array addObject:s];
    }
    
    return [array copy];
}

@end
