//
//  ListProjectsTests.m
//  Fields
//
//  Created by Maria Bernis on 23/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ListProjectsInteractor.h"

@interface ListProjectsTests : XCTestCase
@property (nonatomic, strong) ListProjectsInteractor *pi;
@end

@implementation ListProjectsTests

- (void)setUp {
    [super setUp];
    // This method is called before the invocation of each test method in the class.
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    self.pi = [[ListProjectsInteractor alloc] init];
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

#pragma mark - Testing private methods
- (void)testCreatingTheTemplatesProjectHasTrueForTheBoolean {
    
    BOOL hasMethod = [self.pi respondsToSelector:@selector(_createTemplatesProjectInContext:)];
    XCTAssertTrue(hasMethod);
    
    if (hasMethod) {
        Project *templatesProj = [self.pi performSelector:@selector(_createTemplatesProjectInContext:) withObject:self.pi.defaultMOC];
        
        XCTAssertEqual([templatesProj.templatesContainer boolValue], YES);
    }
}

@end
