//
//  DTO+newLibrary.swift
//
//
//  Created by Edon Valdman on 9/8/24.
//

import Foundation
import SelfServerHelperTypes

extension SelfServerDTOs {
    /// Client-side DTO for `newLibrary` operation.
    ///
    /// Used by `SelfServerRESTClient` as operation input.
    public struct NewLibrary: Sendable {
        public let name: String
        public let deviceID: UUID
        
        public init(name: String, deviceID: UUID) {
            self.name = name
            self.deviceID = deviceID
        }
        
        public struct ConflictError: LocalizedError, Sendable {
            public typealias Body = Components.Responses._409ConflictingLibraryResponse.Body.jsonPayload
            
            public let body: Body
            public let errorCode: SelfServerError
            
            internal init(response: Components.Responses._409ConflictingLibraryResponse) {
                self.body = switch response.body {
                case .json(let body): body
                }
                
                self.errorCode = .init(errorCode: response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code)
                    ?? .newLibraryDeviceIDAlreadyExists
            }
            
            public var errorDescription: String? { errorCode.errorDescription }
            public var failureReason: String? { errorCode.failureReason }
        }
    }
}
