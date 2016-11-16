//
//  CategoryTests.m
//  CategoryTests
//
//  Created by GK on 2016/11/15.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Additions.h"
#import "NSArray+GroupedComponents.h"

@interface CategoryTests : XCTestCase

@end

@implementation CategoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialLetter {
    
    NSString *tempString = @"International Business Machines";
    
    NSString *result = [tempString initials];
    
    XCTAssert([result isEqualToString:@"IBM"],@"string words first letter error");
}
- (void)testDeletePrefix {
    
    NSString *tempString = @"International";
    
    NSString *result = [tempString deletePrefix:@"Int"];
    
    XCTAssert([result isEqualToString:@"ernational"],@"delete prefix error");
}

- (void)testGroupComponents
{
    NSArray *tempArray = @[@"Hildr",@"Heidrun",@"Gerd",@"Freya"];
    
    NSString *result =  [tempArray groupedComponentsWith:[NSLocale currentLocale]];
    
    XCTAssert(result,@"GroupComponents error");
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
