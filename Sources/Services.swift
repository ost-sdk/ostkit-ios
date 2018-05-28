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
public struct OSTError: Error {
    public var code: String
    public var msg: String
    public var data: [String: Any]
    
    init(dict: [String: Any]) {
        code = dict["code"] as? String ?? ""
        msg = dict["msg"] as? String ?? ""
        data = dict["error_data"] as? [String: Any] ?? [:]
    }
}

/// Service error definitions.
public enum ServiceError: Error {
    case parsing
    case ost(OSTError)
}

public class OSTRequest: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return request.description
    }
    
    public var debugDescription: String {
        return request.debugDescription
    }
    
    private var request: DataRequest
    
    init(_ request: DataRequest) {
        self.request = request
    }
    
    public func handlerHookingJSON(
        queue: DispatchQueue? = nil, errorCatcher: ErrorCatcher = DefaultErrorCatcher(),
        completionHandler: @escaping (DataResponse<[String : Any]>) -> Void) -> Self {
        request.responseHookingJSON(queue: queue, errorCatcher: errorCatcher, completionHandler: completionHandler)
        return self
    }
    
    public func handlerData(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Data>) -> Void) -> Self {
        request.responseData(queue: queue, completionHandler: completionHandler)
        return self
    }
    
    public func handlerString(
        queue: DispatchQueue? = nil, encoding: String.Encoding = .utf8,
        completionHandler: @escaping (DataResponse<String>) -> Void) -> Self {
        request.responseString(queue: queue, encoding: encoding, completionHandler: completionHandler)
        return self
    }
    
    public func handlerJSON(
        queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self {
        request.responseJSON(queue: queue, options: options, completionHandler: completionHandler)
        return self
    }
}

/// Base services wrapper
public class Services {
    
    /// Orderby definitions.
    public enum OrderBy: String {
        case creationTime = "creation_time"
        case name = "name"
    }
    
    /// Order definitions.
    public enum Order: String {
        case desc = "desc"
        case asc = "asc"
    }
    
    internal var key: String
    internal var secret: String
    internal var baseURLString: String
    internal var session = Alamofire.SessionManager.default
    
    /// Create service instance
    ///
    /// - parameter endpoint: provide request's info like method, path, input parameters
    /// - parameter baseURLString: base url string
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    /// - parameter debugMode: print request's infomation if true, no otherwise
    init(key: String, secret: String, baseURLString: String) {
        self.key = key
        self.secret = secret
        self.baseURLString = baseURLString
    }
    
    /// Build service's request
    ///
    /// - parameter endPoint: request info
    /// - parameter session: Responsible for creating and managing `Request` objects,
    /// as well as their underlying `NSURLSession`.
    /// - parameter completionHandler: result handler
    internal func createRequest(endPoint: EndPoint) -> OSTRequest {
        let builder = RequestBuilder(
            endpoint: endPoint,
            baseURLString: baseURLString,
            key: key,
            secret: secret
        )
        let request = session.request(builder)
        return OSTRequest(request)
    }
}
