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
    public struct NewLibrary: Hashable, Sendable, Codable {
        public let name: String
        public let deviceID: UUID
        
        public init(name: String, deviceID: UUID) {
            self.name = name
            self.deviceID = deviceID
        }
    }
}
