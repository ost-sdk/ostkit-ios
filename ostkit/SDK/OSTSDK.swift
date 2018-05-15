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
    
    public init(baseURLString: String, key: String, serect: String) {
        self.baseURLString = baseURLString
        self.key = key
        self.secret = serect
    }
    
    public func userServices() -> UserServices {
        let authens = [
            "api_key": key,
            "api_secret": secret
        ]
        
        let services = UserServices(
            authens: authens,
            baseURLString: baseURLString
        )
        return services
    }
    
    public func transactionServices() {
        
    }
}
