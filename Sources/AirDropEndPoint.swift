//
//  AirDropBuilder.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// Airdrop endpoint definitions.
internal enum AirdropEndPoint: EndPoint {
    
    case drop(amount: Float, listType: String)
    
    case status(uuid: String)
    
    var method: EndPointMethod {
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
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .drop(let amount, let listType):
            params["amount"] = amount
            params["list_type"] = listType
            
        case .status(let uuid):
            params["airdrop_uuid"] = uuid
        }
        
        return params
    }
}
