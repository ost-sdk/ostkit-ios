//
//  Services.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// OST request error wrapper
public struct OSTErrorInfo {
    public var code: String
    public var msg: String
    public var data: [String: Any]
    
    init(dict: [String: Any]) {
        code = dict["code"] as? String ?? ""
        msg = dict["msg"] as? String ?? ""
        data = dict["error_data"] as? [String: Any] ?? [:]
    }
}

/// Service result definitions.
public enum ServiceResult<Value> {
    case success(Value)
    case failure(Error)
}

/// Service error definitions.
public enum ServiceError: Error {
    case parsing
    case ost(OSTErrorInfo)
}

/// Base services wrapper
public class Services {
    internal var key: String
    internal var secret: String
    internal var baseURLString: String
    internal var session = Alamofire.SessionManager.default
    internal var debugMode: Bool = false
    
    /// Create service instance
    ///
    /// - parameter endpoint: provide request's info like method, path, input parameters
    /// - parameter baseURLString: base url string
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    /// - parameter debugMode: print request's infomation if true, no otherwise
    init(key: String, secret: String, baseURLString: String, debugMode: Bool = false) {
        self.key = key
        self.secret = secret
        self.baseURLString = baseURLString
        self.debugMode = debugMode
    }
    
    /// Build service's request
    ///
    /// - parameter endPoint: request info
    /// - parameter session: Responsible for creating and managing `Request` objects,
    /// as well as their underlying `NSURLSession`.
    /// - parameter debugMode: print request's infomation if true, no otherwise
    /// - parameter completionHandler: result handler
    internal func createRequest(
        endPoint: EndPoint,
        session: Alamofire.SessionManager,
        debugMode: Bool,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let builder = RequestBuilder(
            endpoint: endPoint,
            baseURLString: baseURLString,
            key: key,
            secret: secret
        )
        let request = session.request(builder)
        request.responseCustomJSON {
            response in
            if let error = response.error {
                completionHandler(.failure(error))
            } else if let json = response.value {
                completionHandler(.success(json))
            } else {
                completionHandler(.failure(ServiceError.parsing))
            }
        }
        
        if debugMode {
            debugPrint(request)
        }
        return request
    }
}
