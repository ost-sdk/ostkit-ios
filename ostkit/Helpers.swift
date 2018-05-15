//
//  Helpers.swift
//  ostkit
//
//  Created by Duong Khong on 5/14/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import CryptoSwift

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
