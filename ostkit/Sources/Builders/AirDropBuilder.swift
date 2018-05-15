//
//  AirDropBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

internal enum AirdropEndPoint {
    
    case drop(amount: Float, listType: String)
    
    case status(uuid: String)
    
    var method: HTTPMethod {
        switch self {
        case .drop:
            return .post
        case .status:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .drop:
            return "/users/airdrop/drop"
            
        case .status:
            return "/users/airdrop/status"
        }
    }
}

internal struct AirdropBuilder: URLRequestConvertible {
    
    internal var endpoint: AirdropEndPoint
    internal var baseURLString: String
    internal var key: String
    internal var secret: String
    
    internal init(endpoint: AirdropEndPoint, baseURLString: String, key: String, secret: String) {
        self.endpoint = endpoint
        self.baseURLString = baseURLString
        self.key = key
        self.secret = secret
    }
    
    private func createRequestParams() -> [String: Any] {
        var params: [String: Any] = [:]
        switch endpoint {
        case .drop(let amount, let listType):
            params["amount"] = amount
            params["list_type"] = listType
            
        case .status(let uuid):
            params["airdrop_uuid"] = uuid
        }
        
        return addSignature(
            params: params, path: endpoint.path,
            key: key, secret: secret
        )
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint.path))
        urlRequest.httpMethod = endpoint.method.rawValue
        
        switch endpoint {
        case .drop:
            let params = createRequestParams()
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            
        case .status:
            let params = createRequestParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        return urlRequest
    }
}
