//
//  AirdropServices.swift
//  ostkit
//
//  Created by Duong Khong on 5/28/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation

public class AirdropServices: Services {
    
    @discardableResult
    public func execute(amount: Float, airdropped: Bool, userIds: String) -> OSTRequest {
        return createRequest(endPoint: AirdropEndPoint.execute(amount: amount, airdropped: airdropped, user_ids: userIds))
    }
    
    @discardableResult
    public func retrieve(id: String) -> OSTRequest {
        return createRequest(endPoint: AirdropEndPoint.retrieve(id: id))
    }
    
    @discardableResult
    public func list(
        page: Int = 1,
        limit: Int = 10,
        airdropped: Bool = false,
        orderBy: OrderBy? = nil,
        order: Order? = nil,
        filter: String) -> OSTRequest {
        
        let endPoint = AirdropEndPoint.list(
            page_no: page, airdropped: airdropped, order_by: orderBy?.rawValue,
            order: order?.rawValue, limit: limit, optional_filters: filter
        )
        
        return createRequest(endPoint: endPoint)
    }
    
}
