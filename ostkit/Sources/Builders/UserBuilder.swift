//
//  UserBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

internal enum UserEndPoint {
    
    /// create user with name
    case create(name: String)
    
    /// edit user's name determine by uuid
    case edit(uuid: String, name: String)
    
    /// get list user
    /// can filter or sort
    case list(pageNo: Int, filter: String?, orderBy: String?, order: String?)
    
    var method: HTTPMethod {
        switch self {
        case .create, .edit:
            return .post
            
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "/users/create"
        case .edit:
            return "/users/edit"
        case .list:
            return "/users/list"
        }
    }
}

internal struct UserBuilder: URLRequestConvertible {
    
    internal var endpoint: UserEndPoint
    internal var baseURLString: String
    internal var key: String
    internal var secret: String
    
    internal init(endpoint: UserEndPoint, baseURLString: String, key: String, secret: String) {
        self.endpoint = endpoint
        self.baseURLString = baseURLString
        self.key = key
        self.secret = secret
    }
    
    private func createRequestParams() -> [String: Any] {
        var params: [String: Any] = [:]
        switch endpoint {
        case .create(let name):
            params["name"] = name
            
        case .edit(let uuid, let name):
            params["uuid"] = uuid
            params["name"] = name
            
        case .list(let pageNo, let filter, let orderBy, let order):
            params["page_no"] = pageNo
            if let filter = filter {
                params["filter"] = filter
            }
            
            if let orderBy = orderBy {
                params["order_by"] = orderBy
            }
            
            if let order = order {
                params["order"] = order
            }
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
        case .create, .edit:
            let params = createRequestParams()
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            
        case .list:
            let params = createRequestParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        return urlRequest
    }
}
