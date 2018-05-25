//
//  OSTSDKTests.swift
//  ostkit
//
//  Created by Duong Khong on 5/25/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import XCTest
@testable import ostkit

class OSTSDKTests: BaseTests {
    func testSDK() {
        let sdk = OSTSDK(baseURLString: baseURLString, key: key, serect: secret)
        XCTAssertEqual(sdk.baseURLString, baseURLString, "base url string was wrong")
        XCTAssertEqual(sdk.key, key, "key was wrong")
        XCTAssertEqual(sdk.secret, secret, "secret was wrong")
        XCTAssertEqual(sdk.debugMode, false, "debugMode is wrong")
    }
}
