//
//  EndPoint.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// Request end point definitions.
protocol EndPoint {
    var method: EndPointMethod { get }
    var path: String { get }
    var params: [String: Any] { get }
}

enum EndPointMethod: String {
    case get
    case post
}
