//
//  RequestBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire

internal struct RequestBuilder: URLRequestConvertible {
    
    internal var endpoint: EndPoint
    internal var baseURLString: String
    internal var key: String
    internal var secret: String
    
    internal init(endpoint: EndPoint, baseURLString: String, key: String, secret: String) {
        self.endpoint = endpoint
        self.baseURLString = baseURLString
        self.key = key
        self.secret = secret
    }
    
    private func generateQueryString(
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
    
    private func addSignature(
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
    
    private func createRequestParams() -> [String: Any] {
        let params = endpoint.params
        return addSignature(
            params: params, path: endpoint.path,
            key: key, secret: secret
        )
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint.path))
        urlRequest.httpMethod = endpoint.method.rawValue
        let params = createRequestParams()
        
        switch endpoint.method {
        case .post:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            
        case .get:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        default:
            break
        }
        return urlRequest
    }
}
