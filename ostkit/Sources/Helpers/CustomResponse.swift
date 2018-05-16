//
//  CustomResponse.swift
//  ostkit
//
//  Created by Duong Khong on 5/16/18.
//  Copyright © 2018 Duong Khong. All rights reserved.
//

import Foundation
import Alamofire

/// hook into alamofire
/// to handle when ost request's error occur
public extension DataRequest {
    
    func handleErrorOccur<T>(jsonObject: Any, result: Result<Any>) -> Result<T>? {
        guard let dict = jsonObject as? [String: Any],
            let success = dict["success"] as? Bool,
            let err = dict["err"] as? [String: Any],
            success == false
            else {
                return nil
        }
        
        let error = OSTErrorInfo(dict: err)
        return .failure(ServiceError.ost(error))
    }
    
    @discardableResult
    public func responseCustomJSON(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[String: Any]>) -> Void) -> Self {
        
        let responseSerializer = DataResponseSerializer<[String: Any]> {
            request, response, data, error in
            
            guard error == nil else {
                return .failure(error!)
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(ServiceError.parsing)
            }
            
            if let failed: Result<[String: Any]> = self.handleErrorOccur(jsonObject: jsonObject, result: result) {
                return failed
            }
            
            guard let finalJSON = jsonObject as? [String: Any] else {
                return .failure(ServiceError.parsing)
            }
            
            return .success(finalJSON)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
