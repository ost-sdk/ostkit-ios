//
//  EndPoint.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

protocol EndPoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var params: [String: Any] { get }
}
