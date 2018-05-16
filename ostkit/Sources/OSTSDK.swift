//
//  OSTSDK.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation

/// Service factory
public class OSTSDK {
    private var baseURLString: String
    private var key: String
    private var secret: String
    public var debugMode: Bool = false
    
    /// Create OSTSDK instance
    ///
    /// - parameter baseURLString: base url string
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    /// - parameter debugMode: print request's infomation if true, no otherwise
    public init(baseURLString: String, key: String, serect: String, debugMode: Bool = false) {
        self.baseURLString = baseURLString
        self.key = key
        self.secret = serect
        self.debugMode = debugMode
    }
    
    /// Factory method to create User Services
    public func userServices() -> UserServices {
        let services = UserServices(
            key: key,
            secret: secret,
            baseURLString: baseURLString,
            debugMode: debugMode
        )
        return services
    }
    
    /// Factory method to create Transaction Type Services
    public func transactionServices() -> TransactionTypeServices {
        let services = TransactionTypeServices(
            key: key,
            secret: secret,
            baseURLString: baseURLString,
            debugMode: debugMode
        )
        return services
    }
}
