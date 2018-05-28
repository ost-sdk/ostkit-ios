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
    
    public enum CurrencyType: String {
        case usd = "USD"
        case bt = "BT"
    }
    
    @discardableResult
    func execute(from_user_id: String, to_user_id: String, action_id: String, amount: String, commission_percent: String) -> OSTRequest {
        let endPoint = TransactionTypeEP.execute(
            from_user_id: from_user_id, to_user_id: to_user_id,
            action_id: action_id, amount: amount,
            commission_percent: commission_percent)
        return createRequest(endPoint: endPoint)
    }
    
    @discardableResult
    func retrieve(id: String) -> OSTRequest {
        return createRequest(endPoint: TransactionTypeEP.retrieve(id: id))
    }
    
    @discardableResult
    public func list(
        page: Int = 1,
        limit: Int = 10,
        airdropped: Bool = false,
        orderBy: OrderBy? = nil,
        order: Order? = nil,
        filter: String) -> OSTRequest {
        
        let endPoint = TransactionTypeEP.list(
            page_no: page, airdropped: airdropped, order_by: orderBy?.rawValue,
            order: order?.rawValue, limit: limit, optional_filters: filter
        )
        
        return createRequest(endPoint: endPoint)
    }
}
