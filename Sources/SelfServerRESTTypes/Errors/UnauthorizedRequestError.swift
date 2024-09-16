//
//  UnauthorizedRequestError.swift
//
//
//  Created by Edon Valdman on 9/16/24.
//

import Foundation
import NIOHTTP1

/// An error type to be thrown when a `401`/`Unauthorized` response type is received.
public struct UnauthorizedRequestError: LocalizedError, Sendable {
    public let statusCode = HTTPResponseStatus.unauthorized
    
    /// The `operationId` of the operation from which this response was received.
    public let operationID: String
    
    /// Header content explaining expected authentication for the failed request.
    public let wwwAuthenticate: String
    
    public init(
        operationID: String,
        wwwAuthenticate: String
    ) {
        self.operationID = operationID
        self.wwwAuthenticate = wwwAuthenticate
    }
    
    /// A convenience initializer from a `401`/`Unauthorized` response, which contains a `WWW-Authenticate` header.
    public init(
        operationID: String,
        response: Components.Responses._401UnauthorizedResponse
    ) {
        self.init(
            operationID: operationID,
            wwwAuthenticate: response.headers.WWW_hyphen_Authenticate
        )
    }
    
    public let errorDescription: String? = "Unauthorized request."
    public var failureReason: String? {
        "Request failed due to missing or incorrect authorization for operation `\(operationID)`."
    }
    
    public var recoverySuggestion: String? {
        "Request must have authentication of the following type: `\(wwwAuthenticate)`."
    }
}
