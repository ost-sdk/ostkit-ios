//
//  UserBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// User's endpoint definitions.
internal enum UserEndPoint: EndPoint {
    
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
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
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
        
        return params
    }
}
