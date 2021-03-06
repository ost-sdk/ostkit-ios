//
//  UserServices.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// User service wrapper
public class UserServices: Services {
    
    /// Filter definitions.
    public enum Filter: String {
        case all = "all"
        case neverAirdropped = "never_airdropped"
    }
    
    /// Orderby definitions.
    public enum OrderBy: String {
        case creationTime = "creation_time"
        case name = "name"
    }
    
    /// Order definitions.
    public enum Order: String {
        case desc = "desc"
        case asc = "asc"
    }
    
    /// Create a new user and obtain a unique identifier
    /// to interact with the created user within your application.
    ///
    /// - parameter name: name of user
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func create(
        name: String,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        return createRequest(
            endPoint: UserEndPoint.create(name: name), session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Edit an existing user for a given unique identifier within the application.
    ///
    /// - parameter uuid: mandatory uuid of the user to edit
    /// - parameter name: name of user
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func edit(
        uuid: String, name: String,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        return createRequest(
            endPoint: UserEndPoint.edit(uuid: uuid, name: name),
            session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
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
        pageNo: Int = 1,
        filter: Filter? = nil,
        orderBy: OrderBy? = nil,
        order: Order? = nil,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        
        let endPoint = UserEndPoint.list(
            pageNo: pageNo, filter: filter?.rawValue,
            orderBy: orderBy?.rawValue, order: order?.rawValue
        )
        
        return createRequest(
            endPoint: endPoint, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Request an airdrop of a certain amount of branded tokens to a set of users.
    ///
    /// - parameter amount: The amount of BT that needs to be air-dropped to the selected end-users. Example:10
    /// - parameter filter: (optional) filter to be applied on list. Possible values: `Filter.all` or `Filter.neverAirdropped`
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func airdropDrop(
        amount: Float,
        listType: Filter = .all,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        
        let endPoint = AirdropEndPoint.drop(
            amount: amount, listType: listType.rawValue
        )
        
        return createRequest(
            endPoint: endPoint, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Get the airdrop status
    ///
    /// - parameter uuid: The unique identifier of your branded token air-drop initiation request,
    /// generated by Initiate Airdrop API. Example: 026d9aba-270b-4ca6-8089-bd2f47a0ecec
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func airdropStatus(
        uuid: String,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        
        let endPoint = AirdropEndPoint.status(uuid: uuid)
        
        return createRequest(
            endPoint: endPoint, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
}
