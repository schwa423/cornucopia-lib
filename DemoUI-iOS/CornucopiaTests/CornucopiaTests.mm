//
//  CornucopiaTests.mm
//  CornucopiaTests
//
//  Created by Josh Gargus on 4/19/15.
//  Copyright (c) 2015 Foo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#include "Test.h"
#include "Debugging.h"
#include <iostream>

namespace {
class PrintDebugging : public Cornu::Debugging {
 public:
  virtual void printf(const char * fmt, ...) {
      va_list argList;
      
      va_start(argList, fmt);
      ::vprintf(fmt, argList);
      va_end(argList);
  }
    
  static void installNew() { Cornu::Debugging::set(new PrintDebugging); }
};
}

@interface CornucopiaTests : XCTestCase

@end

@implementation CornucopiaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    PrintDebugging::installNew();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testAllCornucopiaTests {
    std::vector<TestCase*>& tests = TestCase::allTests();
    for (auto test : tests) {
        Cornu::Debugging::get()->printf("RUNNING CORNUCOPIA TEST");
        std::cout << "Running Cornucopia Test: " << test->name() << std::endl;
        test->run();
    }
}

@end
