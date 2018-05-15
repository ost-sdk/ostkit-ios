//
//  Helpers.swift
//  ostkit
//
//  Created by Duong Khong on 5/14/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire

internal func generateQueryString(
    endpoint: String, params: [String: Any],
    apiKey: String, requestTimestamp: TimeInterval) -> String {
    var _params = params
    _params["api_key"] = apiKey
    _params["request_timestamp"] = String(format: "%.0f", requestTimestamp)
    let queryString = _params.sorted(by: {$0.key < $1.key})
        .map({(key: $0.key, value: "\($0.value)".lowercased())})
        .map({(key: $0.key, value: $0.value.replacingOccurrences(of: " ", with: "+"))})
        .map({"\($0.key)=\($0.value)"})
        .joined(separator: "&")
    return endpoint + "?" + queryString
}

internal func generateApiSignature(
    stringToSign: String, apiSecret: String) throws -> String {
    let hmac = try HMAC(key: apiSecret, variant: .sha256)
    return (try hmac.authenticate(stringToSign.bytes)).toHexString()
}

internal func addSignature(
    params: [String: Any], path: String,
    key: String, secret: String
    ) -> [String: Any] {
    
    var _params = params
    let timeStamp = Date().timeIntervalSince1970
    let queryString = generateQueryString(
        endpoint: path, params: params,
        apiKey: key, requestTimestamp: timeStamp
    )
    
    if let signature = try? generateApiSignature(stringToSign: queryString, apiSecret: secret) {
        _params["signature"] = signature
    }
    _params["request_timestamp"] = String(format: "%.0f", timeStamp)
    _params["api_key"] = key
    return _params
}

internal func createRequest(
    builder: URLRequestConvertible, session: Alamofire.SessionManager,
    debugMode: Bool,
    completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
    ) -> Request? {
    
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

public enum ServiceResult<Value> {
    case success(Value)
    case failure(Error)
}

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

public enum ServiceError: Error {
    case parsing
    case ost(OSTErrorInfo)
}
