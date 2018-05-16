//
//  TransactionTypeBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

enum TransactionTypeEP: EndPoint {
    
    case create(
        name: String, currencyType: String, kind: String,
        currencyValue: Float, commissionPercent: Float
    )
    
    case edit(
        id: String, name: String, currencyType: String, kind: String,
        currencyValue: Float, commissionPercent: Float
    )
    
    case list
    
    case execute(fromUUID: String, toUUID: String, kind: String)
    
    case status(transaction_uuids: String)
    
    var method: HTTPMethod {
        switch self {
        case .create, .edit, .execute:
            return .post
        case .list, .status:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "/transaction-types/create"
        case .edit:
            return "/transaction-types/edit"
        case .list:
            return "/transaction-types/list"
        case .execute:
            return "/transaction-types/execute"
        case .status:
            return "/transaction-types/status"
        }
    }
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .create(let name, let currencyType, let kind, let currencyValue, let commissionPercent):
            params["name"] = name
            params["kind"] = kind
            params["currency_type"] = currencyType
            params["currency_value"] = currencyValue
            params["commission_percent"] = commissionPercent
            
        case .edit(let id, let name, let currencyType, let kind, let currencyValue, let commissionPercent):
            params["client_transaction_id"] = id
            params["name"] = name
            params["kind"] = kind
            params["currency_type"] = currencyType
            params["currency_value"] = currencyValue
            params["commission_percent"] = commissionPercent
            
        case .execute(let fromUUID, let toUUID, let kind):
            params["from_uuid"] = fromUUID
            params["to_uuid"] = toUUID
            params["transaction_kind"] = kind
            
        case .status(let transaction_uuids):
            params["transaction_uuids[]"] = transaction_uuids
            
        default:
            break
        }
        
        return params
    }
}
