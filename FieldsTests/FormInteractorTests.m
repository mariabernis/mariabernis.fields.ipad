

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FormInteractor.h"
#import "ListFormsInteractor.h"
#import "Project.h"

#define test_Project_Title @"Birds"
#define test_form_Title @"Bird counting"

@interface FormInteractorTests : XCTestCase
@property (nonatomic, strong) FormInteractor *fi;
@property (nonatomic, strong) Project *parentProject;
@end

@implementation FormInteractorTests

- (void)setUp {
    [super setUp];
    // This method is called before the invocation of each test method in the class.
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    Project *p = [Project MR_createEntity];
    p.projectTitle = test_Project_Title;
    Form *f = [Form MR_createEntity];
    f.formTitle = test_form_Title;
    f.project = p;
    self.parentProject = p;
    self.fi = [[FormInteractor alloc] initWithForm:f];
    [self.fi.defaultMOC save:nil];
}

- (void)tearDown {
    // This method is called after the invocation of each test method in the class.
    [MagicalRecord cleanUp];
    [super tearDown];
}

- (void)testCreateOneFormInOneProjectFetchRequestReturnsTheNewForm {
    ListFormsInteractor *lfi = [[ListFormsInteractor alloc] init];
    NSFetchRequest *request = [lfi requestAllForProject:self.parentProject];
    NSError *error = nil;
    NSArray *results = [lfi.defaultMOC executeFetchRequest:request error:&error];
    
    XCTAssert(error == nil);
    XCTAssertEqual(1, results.count);
}

@end
