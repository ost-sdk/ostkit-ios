//
//  UserServices.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation

/// User service wrapper
public class UserServices: Services {
    
    /// Create a new user and obtain a unique identifier
    /// to interact with the created user within your application.
    ///
    /// - parameter name: name of user
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func create(name: String) -> OSTRequest {
        return createRequest(endPoint: UserEndPoint.create(name: name))
    }
    
    /// Edit an existing user for a given unique identifier within the application.
    ///
    /// - parameter uuid: mandatory uuid of the user to edit
    /// - parameter name: name of user
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func edit(uuid: String, name: String) -> OSTRequest {
        return createRequest(endPoint: UserEndPoint.edit(uuid: uuid, name: name))
    }
    
    @discardableResult
    public func retrieve(id: String) -> OSTRequest {
        return createRequest(endPoint: UserEndPoint.retrieve(uuid: id))
    }
    
    /// Receive a paginated - optionally filtered - ordered array of users within the economy.
    ///
    /// - parameter pageNo: page number (starts from 1)
    /// - parameter filter: (optional) filter to be applied on list. Possible values: `Filter.all` or `Filter.neverAirdropped`
    /// - parameter orderBy: (optional) order the list by `OrderBy.creationTime` or `OrderBy.name`
    /// - parameter order: (optional) order users in `Order.desc` (default) or `Order.asc` order.
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func list(
        page: Int = 1,
        limit: Int = 10,
        airdropped: Bool = false,
        orderBy: OrderBy? = nil,
        order: Order? = nil,
        filter: String) -> OSTRequest {
        
        let endPoint = UserEndPoint.list(
            page_no: page, airdropped: airdropped, order_by: orderBy?.rawValue,
            order: order?.rawValue, limit: limit, optional_filters: filter
        )
        
        return createRequest(endPoint: endPoint)
    }
}
