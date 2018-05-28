//
//  CustomResponse.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

public protocol ErrorCatcher {
    func handleError(object: Any) -> Error?
}

public extension ErrorCatcher {
    func handleError(object: Any) -> Error? {
        guard let dict = object as? [String: Any],
            let success = dict["success"] as? Bool,
            let err = dict["err"] as? [String: Any],
            success == false
            else {
                return nil
        }
        
        return OSTError(dict: err)
    }
}

public struct DefaultErrorCatcher: ErrorCatcher {
    public init() {}
}

/// hook into alamofire
/// to handle when ost request's error occur
public extension DataRequest {
    
    @discardableResult
    public func responseHookingJSON(
        queue: DispatchQueue? = nil,
        errorCatcher: ErrorCatcher = DefaultErrorCatcher(),
        completionHandler: @escaping (DataResponse<[String: Any]>) -> Void) -> Self {
        
        let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        
        let responseSerializer = DataResponseSerializer<[String: Any]> {
            request, response, data, error in
            
            if let error = error {
                return .failure(error)
            }
            
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(ServiceError.parsing)
            }
            
            if let error = errorCatcher.handleError(object: jsonObject) {
                return .failure(error)
            }
            
            guard let finalJSON = jsonObject as? [String: Any] else {
                return .failure(ServiceError.parsing)
            }
            
            return .success(finalJSON)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
