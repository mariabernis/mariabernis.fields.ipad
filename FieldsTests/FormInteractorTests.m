

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FormInteractor.h"
#import "Project.h"

#define test_Project_Title @"Birds"
#define test_form_Title @"Bird counting"

@interface FormInteractorTests : XCTestCase
@property (nonatomic, strong) FormInteractor *fi;
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
    self.fi = [[FormInteractor alloc] initWithForm:f];
}

- (void)tearDown {
    // This method is called after the invocation of each test method in the class.
    [MagicalRecord cleanUp];
    [super tearDown];
}



@end
