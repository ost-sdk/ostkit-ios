//
//  UserServices.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

public class UserServices: Services {
    
    public enum Filter: String {
        case all = "all"
        case neverAirdropped = "never_airdropped"
    }
    
    public enum OrderBy: String {
        case creationTime = "creation_time"
        case name = "name"
    }
    
    public enum Order: String {
        case desc = "desc"
        case asc = "asc"
    }
    
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
