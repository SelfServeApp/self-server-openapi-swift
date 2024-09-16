//
//  SelfServerError+LocalizedError.swift
//
//
//  Created by Edon Valdman on 9/16/24.
//

import Foundation
import SelfServerHelperTypes

extension SelfServerError: LocalizedError {
    /// Readable error description.
    public var errorDescription: String? {
        switch self {
        case .requestedLibraryNotFound:
            return "Requested Library not found."
        case .restrictedLibraryReqReceivedFromWrongDevice:
            return "Requested Library from unassociated device."
        case .requestedLibraryIDInvalidUUID:
            return "Provided Library ID is invalid UUID."
            
        case .uploadReqPartsNotInOrder:
            return "Asset transfer chunks are not in correct order per asset."
            
        case .newLibraryNameAlreadyExists:
            return "Provided `name` is already used for an existing Library."
        case .newLibraryDeviceIDAlreadyExists:
            return "Provided `deviceID` is already used for an existing Library."
            
        case .wsReqMissingLibraryIDHeader:
            return "WebSocket handshake request is missing required \"X-Self-Serve-Library\" header."
        case .wsLibraryInHeaderDoesNotExist:
            return "WebSocket handshake request's \"X-Self-Serve-Library\" header value doesn't match an existing Library."
            
        case .astNonexistentLibrary:
            return "Authentication token doesn't refer to an a Library that exists."
        case .astIncorrectSessionID:
            return "Authentication token doesn't refer to the correct active session."
        case .astIssuerClaimIncorrect:
            return "Authentication token's issuer claim is incorrect."
        }
    }
    
    /// Readable error explanation.
    public var failureReason: String? {
        switch self {
        case .requestedLibraryNotFound:
            return "Could not find a library with that ID."
        case .restrictedLibraryReqReceivedFromWrongDevice:
            return "Cannot fulfill this request from a device not associated with the specified Library."
        case .requestedLibraryIDInvalidUUID:
            return "`libraryID` path parameter is not a valid UUID."
            
        case .uploadReqPartsNotInOrder:
            return "Consecutively-received chunk parts' `Content-Range` headers refer to ranges not in order."
            
        case .newLibraryNameAlreadyExists:
            return "Cannot create a new Library with the provided `name`, as it's already used for an existing one."
        case .newLibraryDeviceIDAlreadyExists:
            return "Cannot create a new Library with the provided `deviceID`, as it's already used for an existing one."
            
        case .wsReqMissingLibraryIDHeader:
            return "Missing required \"X-Self-Serve-Library\" header."
        case .wsLibraryInHeaderDoesNotExist:
            return "Content of \"X-Self-Serve-Library\" doesn't match an existing Library."
            
        case .astNonexistentLibrary:
            return "Authentication token is invalid, as it is tied to a library that does not exist."
        case .astIncorrectSessionID:
            return "Authentication token is invalid, as it doesn't have the correct active session."
        case .astIssuerClaimIncorrect:
            return "Authentication token's issuer claim does not equal \"self-server:session.token\"."
        }
    }
}

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

