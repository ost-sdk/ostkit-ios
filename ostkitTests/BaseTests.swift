//
//  BaseTests.swift
//  ostkit
//
//  Created by Duong Khong on 5/25/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import XCTest
@testable import ostkit

struct TestTimestamp: RequestTimestamp {
    var timestamp: TimeInterval
    init(timestamp: TimeInterval = Double(1527216538)) {
        self.timestamp = timestamp
    }
}

struct TestEndPoint: EndPoint {
    var method: EndPointMethod
    var path: String
    var params: [String : Any]
    
    init(method: EndPointMethod, path: String, params: [String: Any]) {
        self.method = method
        self.path = path
        self.params = params
    }
}


class BaseTests: XCTestCase {

    let baseURLString = "https://playgroundapi.ost.com"
    let key: String = "wRSyNfyR07nU89zj2yPu"
    let secret: String = "gi9xcyztGEgvSixrPDccFdVBDk8phlqYh3RG9o60lfQ08BbrZ8YSAXuYJhEJ1234"
    let requestTimestamp = TestTimestamp()
    let endPoint = TestEndPoint(method: .get, path: "/test", params: ["Test": "test"])

}
