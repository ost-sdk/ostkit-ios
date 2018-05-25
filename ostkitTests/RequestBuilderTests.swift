//
//  RequestBuilderTests.swift
//  ostkit
//
//  Created by Duong Khong on 5/25/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import XCTest
@testable import ostkit


class RequestBuilderTests: BaseTests {
    
    func testCreatePostRequest() {
        let builder = RequestBuilder(
            endpoint: TestEndPoint(method: .post, path: "/test", params: ["Test": "test"]),
            baseURLString: baseURLString,
            key: key,
            secret: secret,
            requestTimestamp: TestTimestamp()
        )
        
        do {
            let request = try builder.asURLRequest()
            debugPrint(request)
            assert(true)
            
            guard let urlString = request.url?.absoluteString else {
                assert(false, "Can't get url")
            }
            let targetURL = "https://playgroundapi.ost.com/test"
            assert(urlString == targetURL, "get url is wrong")
            
            
            guard let body = request.httpBody,
                let queryString = String(data: body, encoding: .utf8) else {
                assert(false, "Can't get query string")
            }
            let targetqueryString = "Test=test&api_key=wRSyNfyR07nU89zj2yPu&request_timestamp=1527216538&signature=2ff077ce671b1fcfca9eac1783ace74575c4d7702afcad61fc5f3c58bcb4918c"
            assert(queryString == targetqueryString, "query string is wrong")
            
        } catch let error as NSError {
            assert(false, error.localizedDescription)
        }
    }
    
    func testCreateGetRequest() {
        let builder = RequestBuilder(
            endpoint: TestEndPoint(method: .get, path: "/test", params: ["Test": "test"]),
            baseURLString: baseURLString,
            key: key,
            secret: secret,
            requestTimestamp: TestTimestamp()
        )
        
        do {
            let request = try builder.asURLRequest()
            assert(true)
            
            guard let urlString = request.url?.absoluteString else {
                assert(false, "Can't get url")
            }
            
            let targetURL = "https://playgroundapi.ost.com/test?Test=test&api_key=wRSyNfyR07nU89zj2yPu&request_timestamp=1527216538&signature=2ff077ce671b1fcfca9eac1783ace74575c4d7702afcad61fc5f3c58bcb4918c"
            assert(urlString == targetURL, "get url is wrong")
        } catch let error as NSError {
            assert(false, error.localizedDescription)
        }
    }
    
    func testParamsContainArray() {
        let builder = RequestBuilder(
            endpoint: TestEndPoint(method: .get, path: "/test", params: ["Test": "test", "array": [1,2,3]]),
            baseURLString: baseURLString,
            key: key,
            secret: secret,
            requestTimestamp: TestTimestamp()
        )
        
        do {
            let request = try builder.asURLRequest()
            assert(true)
            
            guard let urlString = request.url?.absoluteString else {
                assert(false, "Can't get url")
            }
            debugPrint(urlString)
            let targetURL = "https://playgroundapi.ost.com/test?Test=test&api_key=wRSyNfyR07nU89zj2yPu&array%5B%5D=1&array%5B%5D=2&array%5B%5D=3&request_timestamp=1527216538&signature=f7b0c749b66fcda3c84dc84197c1bda9d18196353d8f78c3ca3d8e557dcf4ab2"
            assert(urlString == targetURL, "get url is wrong")
        } catch let error as NSError {
            assert(false, error.localizedDescription)
        }
    }
}
