//
//  DTO+fileUploadTest.swift
//
//
//  Created by Edon Valdman on 7/13/24.
//

import Foundation
import Photos
import CryptoKit

import SelfServerExtensions

import HTTPFieldTypes

extension SelfServerDTOs {
    /// Client-side DTO for `fileUploadTest` operation.
    ///
    /// Used by `SelfServerRESTClient` as operation input.
    public struct FileUploadTest: Sendable {
        public let libraryID: UUID
        public let transferID: UUID
        public let digestKind: DigestKind
        public let assets: [PHAsset]
        
        public init(libraryID: UUID, transferID: UUID, digestKind: DigestKind = .sha256, assets: [PHAsset]) {
            self.libraryID = libraryID
            self.transferID = transferID
            self.digestKind = digestKind
            self.assets = assets
        }
        
        public enum DigestKind: Hashable, Sendable {
            case md5, sha256, sha512
        }
        
        public enum StreamPart: Hashable, Sendable {
            /// Contains a data chunk of an asset.
            /// - Parameters:
            ///   - chunk: The data chunk.
            ///   - range: The `Content-Range` of this chunk in the context of its containing asset.
            ///   - id: The identifier of the asset to which this chunk belongs.
            ///   - name: The file name of the asset to which this chunk belongs.
            case assetChunk(_ chunk: Data, range: HTTPContentRangeField, id: String, name: String)
            
            /// Indicates an asset has been completely sent.
            /// - Parameters:
            ///   - id: The identifier of the asset to which this part refers to.
            ///   - name: The file name of the asset to which this part refers to.
            ///   - digest: A hashed digest of the complete asset data, to be used to ensure the entire file was received correctly.
            case assetComplete(id: String, name: String, digest: Data)
            
            /// Indicates an asset has been completely sent.
            /// - Parameters:
            ///   - id: The identifier of the asset to which this part refers to.
            ///   - name: The file name of the asset to which this part refers to.
            ///   - digest: A hashed digest of the complete asset data, to be used to ensure the entire file was received correctly.
            fileprivate static func assetComplete<D: Digest>(
                id: String,
                name: String,
                digest: D
            ) -> Self {
                return .assetComplete(id: id, name: name, digest: Data(digest))
            }
        }
        
        /// Creates a stream that outputs parts of ``assets`` organized for a stream transfer operation.
        /// - Parameters:
        ///   - options: Options specifying how Photos should handle the request and notify your app of progress. For details, see [`PHAssetResourceRequestOptions`](https://developer.apple.com/documentation/photokit/phassetresourcerequestoptions).
        ///   - resourceHandler: A handler used to map each `PHAsset` in ``assets`` to a `[PHAssetResource]`.
        public func resourcesStream(
            options: PHAssetResourceRequestOptions?,
            digestKind: DigestKind = .sha256,
            resourceHandler: ((PHAsset) -> [PHAssetResource])? = nil
        ) -> AsyncThrowingStream<StreamPart, Error> {
            let resources = self.assets
                .flatMap {
                    resourceHandler?($0) ?? [$0.primaryResource].compactMap { $0 }
                }
            
            let (stream, continuation) = AsyncThrowingStream.makeStream(of: StreamPart.self, throwing: Error.self)
            var requestIDs = [PHAssetResourceDataRequestID]()
            
            for (i, resource) in resources.enumerated() {
                let fileSize = resource.fileSize
                let chunkRange: (_ chunkSize: Int, _ byteNum: Int) -> HTTPContentRangeField = { chunkSize, byteNum in
                    return .init(
                        unit: .bytes,
                        range: byteNum...(byteNum + chunkSize - 1),
                        totalSize: .known(Int(fileSize))
                    )
                }
                
                var hash: any HashFunction = switch digestKind {
                case .md5:
                    Insecure.MD5()
                case .sha256:
                    SHA256()
                case .sha512:
                    SHA512()
                }
                
                var byteIndex = 0
                let requestID = PHAssetResourceManager.default().requestData(
                    for: resource,
                    options: options) { data in
                        hash.update(data: data)
                        continuation.yield(
                            .assetChunk(
                                data,
                                range: chunkRange(data.count, byteIndex),
                                id: resource.assetLocalIdentifier,
                                name: resource.originalFilename
                            )
                        )
                        byteIndex += data.count
                    } completionHandler: { error in
                        if let error {
                            continuation.yield(with: .failure(error))
                        } else {
                            continuation.yield(
                                .assetComplete(
                                    id: resource.assetLocalIdentifier,
                                    name: resource.originalFilename,
                                    digest: hash.finalize()
                                )
                            )
                        }
                        
                        if i >= resources.count - 1 {
                            continuation.finish()
                        }
                    }
                
                requestIDs.append(requestID)
            }
            
            continuation.onTermination = { [requestIDs] termination in
                guard case .cancelled = termination else { return }
                
                requestIDs.forEach { PHAssetResourceManager.default().cancelDataRequest($0) }
            }
            
            return stream
        }
    }
}
