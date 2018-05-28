//
//  TokenEndPoint.swift
//  ostkit
//
//  Created by Duong Khong on 5/28/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation


enum TokenEndPoint: EndPoint {
    case detail
    
    var method: EndPointMethod {
        return .get
    }
    
    var path: String {
        return "/token"
    }
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        default:
            break
        }
        
        return params
    }
}
