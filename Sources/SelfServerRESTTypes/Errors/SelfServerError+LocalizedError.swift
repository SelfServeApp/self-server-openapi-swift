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
        guard let code = Code(rawValue: UInt(response.headers.X_hyphen_Self_hyphen_Server_hyphen_Error_hyphen_Code)) else { return nil }
        
        switch response.body {
        case .json(let body):
            self.init(code: code, reason: body.reason)
        }
    }
    
    public init(conflict response: Components.Responses._409ConflictingLibraryResponse) {
        switch response.body {
        case .json(let body):
            switch body.conflict {
            case .libraryName:
                self = .newLibraryNameAlreadyExists(
                    name: body.matchingLibrary.name,
                    id: UUID(uuidString: body.matchingLibrary.id)!
                )
            case .deviceID:
                self = .newLibraryDeviceIDAlreadyExists(
                    deviceID: UUID(uuidString: body.matchingLibrary.deviceId)!,
                    existingLibraryName: body.matchingLibrary.name,
                    existingLibraryID: UUID(uuidString: body.matchingLibrary.id)!
                )
            }
        }
    }
}

