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

/// Request builder
/// User `EndPoint` to builder request
internal struct RequestBuilder: URLRequestConvertible {
    
    internal var endpoint: EndPoint
    internal var baseURLString: String
    internal var key: String
    internal var secret: String
    
    /// Create request builder instance
    ///
    /// - parameter endpoint: provide request's info like method, path, input parameters
    /// - parameter baseURLString: base url string
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    internal init(endpoint: EndPoint, baseURLString: String, key: String, secret: String) {
        self.endpoint = endpoint
        self.baseURLString = baseURLString
        self.key = key
        self.secret = secret
    }
    
    /// Create query string which combine from input parameter, path, apikey, requestTimestamp
    ///
    /// - parameter path: request's path
    /// - parameter params: input parameters
    /// - parameter apiKey: the api key as provided from OST
    /// - parameter requestTimestamp: the current unix timestamp in seconds.
    ///
    /// - returns: The string to sign
    private func generateQueryString(
        path: String, params: [String: Any],
        apiKey: String, requestTimestamp: TimeInterval) -> String {
        var _params = params
        _params["api_key"] = apiKey
        _params["request_timestamp"] = String(format: "%.0f", requestTimestamp)
        let queryString = _params.sorted(by: {$0.key < $1.key})
            .map({(key: $0.key, value: "\($0.value)".lowercased())})
            .map({(key: $0.key, value: $0.value.replacingOccurrences(of: " ", with: "+"))})
            .map({"\($0.key)=\($0.value)"})
            .joined(separator: "&")
        return path + "?" + queryString
    }
    
    /// Generate a signature.
    /// The signature is the sha256 digest of the shared API secret
    /// and the correctly formatted query string
    ///
    /// - parameter stringToSign: query string to sign
    /// - parameter apiSecret: the api recret as provided from OST
    ///
    /// - returns: The signature
    internal func generateApiSignature(
        stringToSign: String, apiSecret: String) throws -> String {
        let hmac = try HMAC(key: apiSecret, variant: .sha256)
        return (try hmac.authenticate(stringToSign.bytes)).toHexString()
    }
    
    /// Generate signature then add this signature and
    /// some authenticate parameter to request's input parameters
    ///
    /// - parameter params: current input parameters
    /// - parameter path: request's path
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    ///
    /// - returns: Authenticated parameters
    private func addSignature(
        params: [String: Any], path: String,
        key: String, secret: String
        ) -> [String: Any] {
        
        var _params = params
        let timeStamp = Date().timeIntervalSince1970
        let queryString = generateQueryString(
            path: path, params: params,
            apiKey: key, requestTimestamp: timeStamp
        )
        
        if let signature = try? generateApiSignature(stringToSign: queryString, apiSecret: secret) {
            _params["signature"] = signature
        }
        _params["request_timestamp"] = String(format: "%.0f", timeStamp)
        _params["api_key"] = key
        return _params
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint.path))
        urlRequest.httpMethod = endpoint.method.rawValue
        let params = addSignature(
            params: endpoint.params, path: endpoint.path,
            key: key, secret: secret
        )
        
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
