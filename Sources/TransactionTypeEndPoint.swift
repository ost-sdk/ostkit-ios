//
//  TransactionTypeBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// Transaction type endpoint definitions.
enum TransactionTypeEP: EndPoint {
    
    case execute(from_user_id: String, to_user_id: String, action_id: Double, amount: String, commission_percent: String)
    
    case retrieve(id: String)
    
    case list(
        page_no: Int, airdropped: Bool, order_by: String?,
        order: String?, limit: Int, optional_filters: String?
    )

    
    var method: EndPointMethod {
        switch self {
        case .execute:
            return .post
            
        case .retrieve, .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .execute, .list:
            return "/transactions"
            
        case .retrieve(let id):
            return "/transactions/\(id)"
        }
    }
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
            
        case .execute(let from_user_id, let to_user_id, let action_id, let amount, let commission_percent):
            params["from_user_id"] = from_user_id
            params["to_user_id"] = to_user_id
            params["action_id"] = action_id
            params["amount"] = amount
            params["commission_percent"] = commission_percent
            
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
