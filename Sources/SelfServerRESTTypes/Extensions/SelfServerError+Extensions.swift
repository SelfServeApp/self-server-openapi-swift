//
//  SelfServerError+Extensions.swift
//  
//
//  Created by Edon Valdman on 9/9/24.
//

import Foundation
import SelfServerHelperTypes

extension SelfServerError {
    /// A convenience initializer from a `GeneralError` response, which contains an `X-Self-Server-Error-Code` header.
    ///
    /// It might fail if it's not a valid error code.
    public init?(response: Components.Responses.GeneralError) {
        let errorCodeInt = response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code
        guard let error = SelfServerError(rawValue: UInt(errorCodeInt)) else { return nil }
        self = error
    }
    
    /// A convenience initializer from a `403`/`Forbidden` response, which contains an `X-Self-Server-Error-Code` header.
    ///
    /// It might fail if it's not a valid error code.
    public init?(response: Components.Responses._403ForbiddenResponse) {
        let errorCodeInt = response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code
        guard let error = SelfServerError(rawValue: UInt(errorCodeInt)) else { return nil }
        self = error
    }
}

extension UnauthorizedRequestError {
    /// A convenience initializer from a `401`/`Unauthorized` response, which contains a `WWW-Authenticate` header.
    public init?(operationID: String, response: Components.Responses._401UnauthorizedResponse) {
        self.init(
            operationID: operationID,
            wwwAuthenticate: response.headers.WWW_hyphen_Authenticate
        )
    }
}
