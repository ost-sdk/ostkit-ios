//
//  TransactionTypeServices.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

public class TransactionTypeServices: Services {
    
    public enum Kind: String {
        case userToUser = "user_to_user"
        case companyToUser = "company_to_user"
        case userToCompany = "user_to_company"
    }
    
    
    @discardableResult
    public func create(
        name: String, kind: Kind, currencyType: String,
        currencyValue: Float, commissionPercent: Float,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let ep = TransactionTypeEP.create(
            name: name, currencyType: currencyType, kind: kind.rawValue,
            currencyValue: currencyValue, commissionPercent: commissionPercent
        )
        
        return createRequest(
            endPoint: ep, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
}
