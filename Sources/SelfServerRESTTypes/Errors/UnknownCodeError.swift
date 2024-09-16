//
//  UnknownCodeError.swift
//
//
//  Created by Edon Valdman on 9/16/24.
//

import Foundation

import NIOHTTP1

/// An error type to be thrown when a `GeneralError` response is received, but the value of the `X-Self-Server-Error-Code` header is not recognized.
public struct UnknownCodeError: LocalizedError, Sendable {
    /// The HTTP status code of the response.
    public let statusCode: HTTPResponseStatus
    
    /// The value of the `X-Self-Server-Error-Code` header.
    public let errorCode: Int
    
    /// The `reason` field of the response body.
    public let reason: String?
    
    public init(
        statusCode: HTTPResponseStatus,
        errorCode: Int,
        reason: String?
    ) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.reason = reason
    }
    
    /// A convenience initializer from a `GeneralError` response, used when the content of the `X-Self-Server-Error-Code` header is not a recognized value.
    public init(
        status: HTTPResponseStatus,
        response: Components.Responses.GeneralError
    ) {
        switch response.body {
        case .json(let body):
            self.init(
                statusCode: status,
                errorCode: response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code,
                reason: body.reason
            )
        }
    }
    
    public let errorDescription: String? = "Unknown error code"
    public var failureReason: String? { reason }
}
