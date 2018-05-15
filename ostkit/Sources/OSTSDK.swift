//
//  OSTSDK.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation


public class OSTSDK {
    
    private var baseURLString: String
    private var key: String
    private var secret: String
    public var debugMode: Bool = false
    
    public init(baseURLString: String, key: String, serect: String, debugMode: Bool = false) {
        self.baseURLString = baseURLString
        self.key = key
        self.secret = serect
        self.debugMode = debugMode
    }
    
    public func userServices() -> UserServices {
        
        
        let services = UserServices(
            key: key,
            secret: secret,
            baseURLString: baseURLString,
            debugMode: debugMode
        )
        return services
    }
    
    public func transactionServices() {
        
    }
}
