//
//  ActionEndPoint.swift
//  ostkit
//
//  Created by Duong Khong on 5/28/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation


enum ActionEndPoint: EndPoint {
    
    case create(
        name: String, currency: String, kind: String, arbitrary_amount: Bool,
        amount: String, arbitrary_commission: Bool, commission_percent: Bool
    )
    
    case update(
        id: String, name: String, currency: String, kind: String, arbitrary_amount: Bool,
        amount: String, arbitrary_commission: Bool, commission_percent: Bool
    )
    
    case retrieve(id: String)
    
    case list(
        page_no: Int, airdropped: Bool, order_by: String?,
        order: String?, limit: Int, optional_filters: String?
    )
    
    var method: EndPointMethod {
        switch self {
        case .create, .update:
            return .post
            
        case .retrieve, .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create, .list:
            return "/actions"
            
        case .retrieve(let id):
            return "/actions/\(id)"
            
        case .update(let id, _, _, _, _, _, _, _):
            return "/actions/\(id)"
        }
    }
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
            
        case .create(
            let name, let currency, let kind, let arbitrary_amount,
            let amount, let arbitrary_commission, let commission_percent):
            
            params["name"] = name
            params["currency"] = currency
            params["kind"] = kind
            params["arbitrary_amount"] = arbitrary_amount
            params["amount"] = amount
            params["arbitrary_commission"] = arbitrary_commission
            params["commission_percent"] = commission_percent
            
        case .update(_,
            let name, let currency, let kind, let arbitrary_amount,
            let amount, let arbitrary_commission, let commission_percent):
            
            params["name"] = name
            params["currency"] = currency
            params["kind"] = kind
            params["arbitrary_amount"] = arbitrary_amount
            params["amount"] = amount
            params["arbitrary_commission"] = arbitrary_commission
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
