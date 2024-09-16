//
//  UndocumentedResponseError.swift
//  
//
//  Created by Edon Valdman on 9/16/24.
//

import Foundation

import OpenAPIRuntime
import NIOHTTP1

/// An error type to be thrown when an undocumented response type is received.
public struct UndocumentedResponseError: LocalizedError, Sendable {
    /// The HTTP status code of the response.
    public let statusCode: HTTPResponseStatus
    
    /// The HTTP payload of the response.
    public let payload: OpenAPIRuntime.UndocumentedPayload
    
    public init(
        statusCode: HTTPResponseStatus,
        payload: OpenAPIRuntime.UndocumentedPayload
    ) {
        self.statusCode = statusCode
        self.payload = payload
    }
    
    public var failureReason: String? {
        statusCode.reasonPhrase
    }
}
