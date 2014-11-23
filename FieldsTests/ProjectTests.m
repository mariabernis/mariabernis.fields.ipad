
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MBCoreDataStack.h"
#import "Project.h"


@interface ProjectTests : XCTestCase

@end


@implementation ProjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [MagicalRecord cleanUp];
    [super tearDown];
}

- (void)testNewEmptyProjectHasSomeTitleFilledIn {
    
    Project *p = [Project MR_createEntity];
    XCTAssertNotNil(p);
    XCTAssertTrue(p.projectTitle.length > 1);
}


- (void)testNewEmptyProjectHasEmptyDescription {
    Project *p = [Project MR_createEntity];
    XCTAssertTrue(p.projectDescription == nil);
}

- (void)testNewEmptyProjectHasFalseForTheTemplatesBoolean {
    Project *p = [Project MR_createEntity];
    XCTAssertTrue([p.templatesContainer boolValue] == NO);
}

@end
