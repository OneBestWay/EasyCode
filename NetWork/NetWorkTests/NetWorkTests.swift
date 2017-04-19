//
//  NetWorkTests.swift
//  NetWorkTests
//
//  Created by GK on 2017/1/10.
//  Copyright © 2017年 GK. All rights reserved.
//

import XCTest

class NetWorkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserRequest() {
        
        LocalFileClient.default.send(UserRequest(name:"onevcat")) { [weak self] result in
            switch result {
            case .Success(let user):
                
                print("\(user.message),\(user.name)")
            case .Failure(let error):
                print("a error accure")
            }
        }
    }
}
