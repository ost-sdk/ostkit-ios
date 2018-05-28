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
    internal var baseURLString: String
    internal var key: String
    internal var secret: String
    
    /// Create OSTSDK instance
    ///
    /// - parameter baseURLString: base url string
    /// - parameter key: the api key as provided from OST
    /// - parameter sectect: the api recret as provided from OST
    /// - parameter debugMode: print request's infomation if true, no otherwise
    public init(baseURLString: String, key: String, serect: String) {
        self.baseURLString = baseURLString
        self.key = key
        self.secret = serect
    }
    
    /// Factory method to create User Services
    public func userServices() -> UserServices {
        let services = UserServices(
            key: key,
            secret: secret,
            baseURLString: baseURLString
        )
        return services
    }
    
    /// Factory method to create Transaction Type Services
    public func transactionServices() -> TransactionTypeServices {
        let services = TransactionTypeServices(
            key: key,
            secret: secret,
            baseURLString: baseURLString
        )
        return services
    }
    
    public func airdropServices() -> AirdropServices {
        let services = AirdropServices(
            key: key,
            secret: secret,
            baseURLString: baseURLString
        )
        return services
    }
}
