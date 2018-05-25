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
        assert(services.baseURLString == baseURLString, "base url string was wrong")
        assert(services.key == key, "key was wrong")
        assert(services.secret == secret, "secret was wrong")
        assert(services.debugMode == false, "debugMode is wrong")
    }

}
