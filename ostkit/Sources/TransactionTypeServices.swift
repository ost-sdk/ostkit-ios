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
    
    /// Create a new transaction-type. Transaction types allow users to exchange branded tokens
    /// between each other for actions within the application or with the company.
    ///
    /// - parameter name: name of the transaction type
    /// - parameter kind: transaction types can be one of three kinds: `Kind.userToUser`,
    /// `Kind.companyToUser`, or `Kind.userToCompany` to clearly determine whether value flows
    /// within the application or from or to the company.
    /// On user to user transfers the company can ask a transaction fee.
    ///
    /// - parameter currencyType: type of currency the transaction is valued in.
    /// Possible values are "USD" (fixed) or "BT" (floating).
    /// When a transaction type is set in fiat value the equivalent amount of branded tokens
    /// are calculated on-chain over a price oracle. A transaction fails if the price point
    /// is outside of the accepted margins set by the company (API not yet exposed).
    /// For OST KIT⍺ price points are calculated by and taken from coinmarketcap.com and
    /// published to the contract by OST.com.
    ///
    /// - parameter currencyValue: value of the transaction set in "USD" (min USD 0.01 , max USD 100)
    /// or branded token "BT" (min BT 0.00001, max BT 100). The transfer on-chain always occurs in
    /// branded token and for fiat value is calculated to the equivalent amount of branded tokens
    /// at the moment of transfer. If the transaction type is between users and a commission percentage
    /// is set then the commission is inclusive in this value and the complement goes to the beneficiary user.
    ///
    /// - parameter commissionPercent: inclusive percentage of the value that is sent to company.
    /// Possible only for "user_to_user" transaction kind. (min 0%, max 100%)
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func create(
        name: String, kind: Kind, currencyType: CurrencyType,
        currencyValue: Float, commissionPercent: Float,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let ep = TransactionTypeEP.create(
            name: name, currencyType: currencyType.rawValue, kind: kind.rawValue,
            currencyValue: currencyValue, commissionPercent: commissionPercent
        )
        return createRequest(
            endPoint: ep, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Edit an exisiting transaction-type for a given unique identifier that
    /// was returned during the creation of a new transaction type.
    /// This updates the specified transaction type by setting the values of the parameters passed.
    /// Any parameter not provided will be left unchanged. Individual keys can be unset by posting an empty value to them.
    ///
    /// - parameter id: mandatory id for transaction to edit
    /// - parameter name: name of the transaction type
    /// - parameter kind: transaction types can be one of three kinds: `Kind.userToUser`,
    /// `Kind.companyToUser`, or `Kind.userToCompany` to clearly determine whether value flows
    /// within the application or from or to the company.
    /// On user to user transfers the company can ask a transaction fee.
    ///
    /// - parameter currencyType: type of currency the transaction is valued in.
    /// Possible values are "USD" (fixed) or "BT" (floating).
    /// When a transaction type is set in fiat value the equivalent amount of branded tokens
    /// are calculated on-chain over a price oracle. A transaction fails if the price point
    /// is outside of the accepted margins set by the company (API not yet exposed).
    /// For OST KIT⍺ price points are calculated by and taken from coinmarketcap.com and
    /// published to the contract by OST.com.
    ///
    /// - parameter currencyValue: value of the transaction set in "USD" (min USD 0.01 , max USD 100)
    /// or branded token "BT" (min BT 0.00001, max BT 100). The transfer on-chain always occurs in
    /// branded token and for fiat value is calculated to the equivalent amount of branded tokens
    /// at the moment of transfer. If the transaction type is between users and a commission percentage
    /// is set then the commission is inclusive in this value and the complement goes to the beneficiary user.
    ///
    /// - parameter commissionPercent: inclusive percentage of the value that is sent to company.
    /// Possible only for "user_to_user" transaction kind. (min 0%, max 100%)
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func edit(
        id: String, name: String, kind: Kind, currencyType: String,
        currencyValue: Float, commissionPercent: Float,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let ep = TransactionTypeEP.edit(
            id: id, name: name, currencyType: currencyType, kind: kind.rawValue,
            currencyValue: currencyValue, commissionPercent: commissionPercent
        )
        return createRequest(
            endPoint: ep, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Execute a defined transaction type between users and/or the company.
    ///
    /// - parameter fromUUID: user or company from whom to send the funds
    /// - parameter toUUID: user or company to whom to send the funds
    /// - parameter transKind: name of the transaction type to be executed,
    /// e.g. "Upvote" (note that the parameter is a misnomer currently)
    ///
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func execute(
        fromUUID: String, toUUID: String, transKind: String,
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let ep = TransactionTypeEP.execute(
            fromUUID: fromUUID, toUUID: toUUID, kind: transKind
        )
        return createRequest(
            endPoint: ep, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Receive a list of all transaction types. In addition client_id, price_points,
    /// and client_tokens are returned.
    ///
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func list(
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let ep = TransactionTypeEP.list
        return createRequest(
            endPoint: ep, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
    
    /// Query the status of executed transactions.
    /// Multiple uuids can be passed in a single request to receive the status of all.
    ///
    /// - parameter uuids: unique identifier for an executed transaction that is part of an array
    /// - parameter completionHandler: handler
    /// - returns: Alamofire's Request
    @discardableResult
    public func status(
        uuids: [String],
        completionHandler: @escaping (ServiceResult<[String: Any]>) -> Void
        ) -> Request? {
        let ep = TransactionTypeEP.status(transaction_uuids: uuids)
        return createRequest(
            endPoint: ep, session: session,
            debugMode: debugMode, completionHandler: completionHandler
        )
    }
}
