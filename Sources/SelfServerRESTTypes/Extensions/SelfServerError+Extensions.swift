//
//  SelfServerError+Extensions.swift
//
//
//  Created by Edon Valdman on 9/9/24.
//

import Foundation
import SelfServerHelperTypes

import NIOHTTP1

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

extension UnauthorizedRequestError {
    /// A convenience initializer from a `401`/`Unauthorized` response, which contains a `WWW-Authenticate` header.
    public init(operationID: String, response: Components.Responses._401UnauthorizedResponse) {
        self.init(
            operationID: operationID,
            wwwAuthenticate: response.headers.WWW_hyphen_Authenticate
        )
    }
}

extension UnknownCodeError {
    /// A convenience initializer from a `GeneralError` response, used when the content of the `X-Self-Server-Error-Code` header is not a recognized value.
    public init(status: HTTPResponseStatus, response: Components.Responses.GeneralError) {
        switch response.body {
        case .json(let body):
            self.init(
                statusCode: status,
                errorCode: response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code,
                reason: body.reason
            )
        }
    }
}
