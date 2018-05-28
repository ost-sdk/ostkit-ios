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
    
    /// retrieve
    case retrieve(uuid: String)
    
    /// get list user
    /// can filter or sort
    case list(
        page_no: Int, airdropped: Bool, order_by: String?,
        order: String?, limit: Int, optional_filters: String?
    )
    
    var method: EndPointMethod {
        switch self {
        case .create, .edit:
            return .post
            
        case .list, .retrieve:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create, .list:
            return "/users"
            
        case .edit(let id, _):
            return "/users/\(id)"
            
        case .retrieve(let id):
            return "/users/\(id)"
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
            
        case .list(
            let page_no, let airdropped, let order_by,
            let order, let limit, let optional_filters):
            
            params["page_no"] = page_no
            params["airdropped"] = airdropped
            params["limit"] = limit
            
            if let optional_filters = optional_filters {
                params["optional_filters"] = optional_filters
            }
            
            if let order_by = order_by {
                params["order_by"] = order_by
            }
            
            if let order = order {
                params["order"] = order
            }
            
        default:
            break
        }
        
        return params
    }
}
