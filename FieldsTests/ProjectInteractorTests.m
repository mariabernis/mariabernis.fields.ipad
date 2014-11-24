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
@property (nonatomic, strong) Project *project;
@end



@implementation ProjectInteractorTests

- (void)setUp {
    [super setUp];
    // This method is called before the invocation of each test method in the class.
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    self.lpi = [[ListProjectsInteractor alloc] init];
    
    Project *p = [Project MR_createEntity];
    p.projectTitle = test_Project_Title;
    self.project = p;
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

- (void)testDeletingTemplatesProjectReturnsError {
    
    [self.pip deleteProject:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
    }];
    
}

- (void)testCallingUpdateWithSameInspectionTitleSaysNoChanges {
    
    BOOL changed = [self.pip isChangedTitle:test_Project_Title orDescription:nil];
    XCTAssertEqual(changed, NO);
}

- (void)testCallingUpdateWithSameInspectionTitleAndDescripSaysNoChanges {
    
    Project *p = [Project MR_createEntity];
    p.projectTitle = @"Inspection";
    p.projectDescription = @"text";
    ProjectInteractor *pi = [[ProjectInteractor alloc] initWithProject:p];
    
    BOOL changed = [pi isChangedTitle:@"  Inspection     " orDescription:@"  text "];
    XCTAssertEqual(changed, NO);
}

- (void)testCallingUpdateWithSameTitleAndNilDescripSaysHASChanges {
    
    Project *p = [Project MR_createEntity];
    p.projectTitle = test_Project_Title;
    p.projectDescription = @"text";
    ProjectInteractor *pi = [[ProjectInteractor alloc] initWithProject:p];
    
    BOOL changed = [pi isChangedTitle:test_Project_Title orDescription:nil];
    XCTAssertEqual(changed, YES);
}

- (void)testCallingUpdateWithNilTitleAndSameDescripSaysHASChanges {
    
    Project *p = [Project MR_createEntity];
    p.projectTitle = test_Project_Title;
    p.projectDescription = @"text";
    ProjectInteractor *pi = [[ProjectInteractor alloc] initWithProject:p];
    
    BOOL changed = [pi isChangedTitle:nil orDescription:@" text "];
    XCTAssertEqual(changed, YES);
}

@end
