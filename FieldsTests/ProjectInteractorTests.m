//
//  ProjectInteractorTests.m
//  Fields
//
//  Created by Maria Bernis on 23/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MBCoreDataStack.h"
#import "ProjectInteractor.h"
#import "ListProjectsInteractor.h"
#import "MBCheck.h"

#define test_Project_Title @"Inspection"

@interface ProjectInteractorTests : XCTestCase
@property (nonatomic, strong) ListProjectsInteractor *lpi;
@property (nonatomic, strong) ProjectInteractor *pip;
@end



@implementation ProjectInteractorTests

- (void)setUp {
    [super setUp];
    // This method is called before the invocation of each test method in the class.
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    self.lpi = [[ListProjectsInteractor alloc] init];
    
    Project *p = [Project MR_createEntity];
    p.projectTitle = test_Project_Title;
    self.pip = [[ProjectInteractor alloc] initWithProject:p];
}

- (void)tearDown {
    // This method is called after the invocation of each test method in the class.
    [MagicalRecord cleanUp];
    [super tearDown];
}



- (void)testSaveNewProjectWithEmptyTitleReturnsError {
    
    NSUInteger preCount = [Project MR_countOfEntities];
    
    [self.pip saveNewProjectWithTitle:@"   " andDescription:nil completion:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
        NSUInteger postCount = [Project MR_countOfEntities];
        XCTAssertEqual(preCount, postCount);
    }];
}

- (void)testUpdateProjectWithEmptyTitleReturnsError {
    
    [self.pip updateProjectWithTitle:@"  "
                     andDescription:nil
                         completion:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
        Project *p = (Project *)[self.pip valueForKey:@"project"];
        XCTAssertEqualObjects(test_Project_Title, p.projectTitle);
    }];

}

- (void)testEditingTemplatesProjectReturnsError {
    
    NSFetchRequest *request = [self.lpi requestAllDefault];
//    NSArray *projs = [Project MR_executeFetchRequest:request inContext:self.pi
//                      .defaultMOC];
    NSArray *projs = [Project MR_executeFetchRequest:request];
    Project *p = [projs lastObject];
    ProjectInteractor *tPip = [[ProjectInteractor alloc] initWithProject:p];
    [tPip updateProjectWithTitle:@"New Title" andDescription:@"lorem lorem" completion:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNotEqualObjects(@"New Title", p.projectTitle);
    }];
}



- (void)testCreatingNewProjectHasFalseForTheTemplateBoolean {
    
    BOOL hasMethod = [self.pip respondsToSelector:@selector(_createNewProjectInContext:withTitle:andDescription:)];
    XCTAssertTrue(hasMethod);
    
    if (hasMethod) {
        Project *normalProj = [self.pip performSelector:@selector(_createNewProjectInContext:withTitle:andDescription:) withObject:self.pip.defaultMOC withObject:@"Lorem ipsum"];
        
        XCTAssertEqual([normalProj.templatesContainer boolValue], NO);
    }
}


@end
