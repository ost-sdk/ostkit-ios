//
//  TransferEndPoint.swift
//  ostkit
//
//  Created by Duong Khong on 5/28/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation

enum TransferEndPoint: EndPoint {
    
    case create(to_address: String, amount: Double)
    case retrieve(id: String)
    case list(
        page_no: Int, airdropped: Bool, order_by: String?,
        order: String?, limit: Int, optional_filters: String?
    )
    
    var method: EndPointMethod {
        switch self {
        case .create:
            return .post
            
        case .retrieve, .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create, .list:
            return "/transfers"
            
        case .retrieve(let id):
            return "/transfers/\(id)"
            
        }
    }
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
            
        case .create(let to_address, let amount):
            params["to_address"] = to_address
            params["amount"] = amount
            
            
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
