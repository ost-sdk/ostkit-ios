//
//  ServicesTests.swift
//  ostkit
//
//  Created by Duong Khong on 5/25/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import XCTest
@testable import ostkit

class ServicesTests: BaseTests {

    func testServices() {
        let services = Services(key: key, secret: secret, baseURLString: baseURLString)
        XCTAssertEqual(services.baseURLString, baseURLString, "base url string was wrong")
        XCTAssertEqual(services.key, key, "key was wrong")
        XCTAssertEqual(services.secret, secret, "secret was wrong")
        XCTAssertEqual(services.debugMode, false, "debugMode is wrong")
    }

}
