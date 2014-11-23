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
#import "MBCheck.h"

@interface ProjectInteractorTests : XCTestCase
@property (nonatomic, strong) ProjectInteractor *pi;
@end



@implementation ProjectInteractorTests

- (void)setUp {
    [super setUp];
    // This method is called before the invocation of each test method in the class.
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    self.pi = [[ProjectInteractor alloc] init];
}

- (void)tearDown {
    // This method is called after the invocation of each test method in the class.
    [MagicalRecord cleanUp];
    [super tearDown];
}

- (void)testFirstTimeRequestingProjectsOneIsCreatedForTheTemplates {
    
    NSUInteger initialCount = [Project MR_countOfEntities];
    NSFetchRequest *request = [self.pi requestAllDefault];
    NSError *error = nil;
    NSUInteger afterCount = [self.pi.defaultMOC countForFetchRequest:request error:&error];
    
    XCTAssertTrue(initialCount != NSNotFound);
    XCTAssertTrue(afterCount != NSNotFound);
    XCTAssertEqual(initialCount, 0);
    XCTAssertEqual(afterCount, 1);
}

- (void)testSaveNewProjectWithEmptyTitleReturnsError {
    
    [self.pi requestAllDefault];
    NSUInteger preCount = [Project MR_countOfEntities];
    
    [self.pi saveNewProjectWithTitle:@"   " andDescription:nil completion:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
        NSUInteger postCount = [Project MR_countOfEntities];
        XCTAssertEqual(preCount, postCount);
    }];
}

- (void)testUpdateProjectWithEmptyTitleReturnsError {
    
    [self.pi requestAllDefault];
    Project *p = [Project MR_createEntity];
    p.projectTitle = @"Inspection";
    [self.pi.defaultMOC save:nil];
    NSUInteger preCount = [Project MR_countOfEntities];
    
    ProjectInteractor *pip = [[ProjectInteractor alloc] initWithProject:p];
    [pip updateProjectWithTitle:@"  "
                     andDescription:nil
                         completion:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
        NSUInteger postCount = [Project MR_countOfEntities];
        XCTAssertEqual(preCount, postCount);
    }];

}

#pragma mark - Testing private methods
- (void)testCreatingTheTemplatesProjectHasTrueForTheBoolean {
    
    BOOL hasMethod = [self.pi respondsToSelector:@selector(_createTemplatesProjectInContext:)];
    XCTAssertTrue(hasMethod);
    
    if (hasMethod) {
        Project *templatesProj = [self.pi performSelector:@selector(_createTemplatesProjectInContext:) withObject:self.pi.defaultMOC];
        
        XCTAssertEqual([templatesProj.templatesContainer boolValue], YES);
    }
}

- (void)testCreatingNewProjectHasFalseForTheTemplateBoolean {
    
    BOOL hasMethod = [self.pi respondsToSelector:@selector(_createNewProjectInContext:withTitle:andDescription:)];
    XCTAssertTrue(hasMethod);
    
    if (hasMethod) {
        Project *normalProj = [self.pi performSelector:@selector(_createNewProjectInContext:withTitle:andDescription:) withObject:self.pi.defaultMOC withObject:@"Lorem ipsum"];
        
        XCTAssertEqual([normalProj.templatesContainer boolValue], NO);
    }
}


@end
