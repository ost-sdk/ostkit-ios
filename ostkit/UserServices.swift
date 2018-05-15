//
//  UserServices.swift
//  ostkit
//
//  Created by Duong Khong on 5/15/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire


public class UserServices {
    
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
    
    private var authens: [String: Any]
    private var baseURLString: String
    private var session = Alamofire.SessionManager.default
    private var debugMode: Bool = false
    
    init(authens: [String: Any], baseURLString: String, debugMode: Bool = false) {
        self.authens = authens
        self.baseURLString = baseURLString
        self.debugMode = debugMode
    }
    
    @discardableResult
    public func create(
        name: String,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let builder = UserBuilder(
            endpoint: .create(name: name),
            baseURLString: baseURLString,
            authens: authens
        )
        
        let request = session.request(builder)
        request.responseCustomJSON {
            response in
            if let error = response.error {
                completionHandler(.failure(error))
            } else if let json = response.value {
                completionHandler(.success(json))
            } else {
                completionHandler(.failure(ServiceError.parsing))
            }
        }
        
        if debugMode {
            debugPrint(request)
        }
        return request
    }
    
    @discardableResult
    public func edit(
        uuid: String, name: String,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let builder = UserBuilder(
            endpoint: .edit(uuid: uuid, name: name),
            baseURLString: baseURLString,
            authens: authens
        )
        
        let request = session.request(builder)
        request.responseCustomJSON {
            response in
            if let error = response.error {
                completionHandler(.failure(error))
            } else if let json = response.value {
                completionHandler(.success(json))
            } else {
                completionHandler(.failure(ServiceError.parsing))
            }
        }
        
        if debugMode {
            debugPrint(request)
        }
        return request
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
        
        let builder = UserBuilder(
            endpoint: endPoint,
            baseURLString: baseURLString,
            authens: authens
        )
        
        let request = session.request(builder)
        request.responseCustomJSON {
            response in
            if let error = response.error {
                completionHandler(.failure(error))
            } else if let json = response.value {
                completionHandler(.success(json))
            } else {
                completionHandler(.failure(ServiceError.parsing))
            }
        }
        
        if debugMode {
            debugPrint(request)
        }
        return request
    }
}
