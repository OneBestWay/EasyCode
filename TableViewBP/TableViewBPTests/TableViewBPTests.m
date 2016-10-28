//
//  TableViewBPTests.m
//  TableViewBPTests
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContactsPeople.h"

@interface TableViewBPTests : XCTestCase

@end

@implementation TableViewBPTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testChinesePinYinFirstLetter
{
    NSString *nameKey = [ContactsPeople chinesePinYinFirstLetter:@"我是"];
    NSLog(@"我是:%@",nameKey);
    
    XCTAssert([@"W" isEqualToString:nameKey],@"get chianese PinYin first letter error");
    
    NSString *name2Key = [ContactsPeople chinesePinYinAllWordFirstLetter:@"是我"];
    NSLog(@"是我:%@",name2Key);
    
    XCTAssert([@"SW" isEqualToString:name2Key],@"get chianese PinYin first letter error");
    
    NSString *nameKey3 = [ContactsPeople chinesePinYinFirstLetter:@"  "];
    NSLog(@"  :%@",nameKey3);
    
    XCTAssert([@" " isEqualToString:nameKey3],@"get chianese PinYin first letter error");
    
    NSString *nameKey4 = [ContactsPeople chinesePinYinFirstLetter:@"cd"];
    NSLog(@"C:%@",nameKey4);
    
    XCTAssert([@"C" isEqualToString:nameKey4],@"get chianese PinYin first letter error");
    
}
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
