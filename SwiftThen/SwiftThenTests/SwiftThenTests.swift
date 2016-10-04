//
//  SwiftThenTests.swift
//  SwiftThenTests
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

import XCTest
@testable import SwiftThen

struct User {
    var name: String?
    var email: String?
}

extension User: Then {}

class SwiftThenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThen() {
        let queue = OperationQueue().then {
            $0.name = "awesome"
            $0.maxConcurrentOperationCount = 5
        }
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 5)
    }
    
    func testWith() {
        let user = User().with {
            $0.name = "devxoul"
            $0.email = "devxou;@gmail.com"
        }
        XCTAssertEqual(user.name, "devxoul")
        XCTAssertEqual(user.email, "devxou;@gmail.com")
    }
    
    func testDo() {
        UserDefaults.standard.do {
            $0.removeObject(forKey: "username")
            $0.set("devxoul", forKey: "username")
            $0.synchronize()
        }
        XCTAssertEqual(UserDefaults.standard.string(forKey: "username"), "devxoul")
    }
    
}
