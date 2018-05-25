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

public protocol RequestTimestamp {
    var timestamp: TimeInterval { get }
}

public struct CurrentTimestamp: RequestTimestamp {
    public var timestamp: TimeInterval {
        return Date().timeIntervalSince1970
    }
}

/// Request builder
/// User `EndPoint` to builder request
internal struct RequestBuilder: URLRequestConvertible {
    
    internal var endpoint: EndPoint
    internal var baseURLString: String
    internal var key: String
    internal var secret: String
    internal var requestTimestamp: RequestTimestamp
    
    /// Create request builder instance
    ///
    /// - parameter endpoint: provide request's info like method, path, input parameters
    /// - parameter baseURLString: base url string
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    internal init(
        endpoint: EndPoint, baseURLString: String, key: String,
        secret: String, requestTimestamp: RequestTimestamp = CurrentTimestamp()) {
        self.endpoint = endpoint
        self.baseURLString = baseURLString
        self.key = key
        self.secret = secret
        self.requestTimestamp = requestTimestamp
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
        path: String, params: [String: Any], apiKey: String,
        requestTimestamp: TimeInterval, urlRequest: URLRequest) -> String {
        
        var _params = params
        _params["api_key"] = apiKey
        _params["request_timestamp"] = String(format: "%.0f", requestTimestamp)
        
        if let urlRequest = try? URLEncoding.default.encode(urlRequest, with: _params) {
            if let url = urlRequest.url,
                let queryString = url.query,
                endpoint.method == .get {
                return path + "?" + queryString.replacingOccurrences(of: "%20", with: "+")
                
            } else if let body = urlRequest.httpBody,
                let queryString = String(data: body, encoding: .utf8),
                endpoint.method == .post {
                return path + "?" + queryString.replacingOccurrences(of: "%20", with: "+")
                
            }
        }
        
        return ""
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
        key: String, secret: String, urlRequest: URLRequest
        ) -> [String: Any] {
        
        var _params = params
        let timeStamp = requestTimestamp.timestamp
        let queryString = generateQueryString(
            path: path, params: params,
            apiKey: key, requestTimestamp: timeStamp,
            urlRequest: urlRequest
        )
    
        if let signature = try? generateApiSignature(stringToSign: queryString, apiSecret: secret) {
            _params["signature"] = signature
        }
        _params["request_timestamp"] = String(format: "%.0f", timeStamp)
        _params["api_key"] = key
        return _params
    }
    
    /// URLRequestConvertible confirmation
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint.path))
        urlRequest.httpMethod = endpoint.method.rawValue
        
        let params = addSignature(
            params: endpoint.params, path: endpoint.path,
            key: key, secret: secret, urlRequest: urlRequest
        )
        
        urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        
        return urlRequest
    }
}
