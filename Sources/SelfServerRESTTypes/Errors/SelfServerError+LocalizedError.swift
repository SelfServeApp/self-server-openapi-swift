//
//  SelfServerError+LocalizedError.swift
//
//
//  Created by Edon Valdman on 9/16/24.
//

import Foundation
import SelfServerHelperTypes

extension SelfServerError {
    /// A convenience initializer from a `GeneralError` response, which contains an `X-Self-Server-Error-Code` header.
    ///
    /// It might fail if it's not a valid error code.
    public init?(response: Components.Responses.GeneralError) {
        self.init(errorCode: response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code)
    }
    
    /// A convenience initializer from a `GeneralError` response, which contains an `X-Self-Server-Error-Code` header.
    ///
    /// It might fail if it's not a valid error code.
    public init?(errorCode header: Components.Headers.XSelfServerErrorCode) {
        self.init(rawValue: UInt(header))
    }
}

