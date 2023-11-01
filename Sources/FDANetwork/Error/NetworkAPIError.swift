//
//  NetworkAPIError.swift
//
//  Created by Sergio Fresneda on 10/10/23.
//

import Foundation

/// Class that contains the error
final class NetworkAPIError {
    
    /// Status code of the error
    let statusCode: Int

    /// Detail of the error
    private let errorDescription: NetworkAPIErrorDetail

    /// Detail of the error
    var localizedDescription: String {
        errorDescription.detail
    }

    /// Initializer of the struct with error description model
    init(statusCode: Int, errorDescription: NetworkAPIErrorDetail) {
        self.statusCode = statusCode
        self.errorDescription = errorDescription
    }

    /// Initializer of the struct with error description string
    init(statusCode: Int, detail: String) {
        self.statusCode = statusCode
        self.errorDescription = NetworkAPIErrorDetail(detail: detail)
    }
}

// MARK: - Equatable
extension NetworkAPIError: Equatable {
    static func == (lhs: NetworkAPIError, rhs: NetworkAPIError) -> Bool {
        lhs.statusCode == rhs.statusCode
        && lhs.errorDescription == lhs.errorDescription
    }
}

// MARK: - Error
extension NetworkAPIError {
    /// Error that indicates that the app needs to reset
    static var reset: NetworkAPIError {
        NetworkAPIError(statusCode: 0, detail: "App needs to reset")
    }

    /// Error that indicates that the network response has no response
    static var noResponse: NetworkAPIError {
        NetworkAPIError(statusCode: -1, detail: "No response")
    }

    /// Error that indicates that the url is not valid
    static func badUrl(_ url: URL?) -> NetworkAPIError {
        NetworkAPIError(statusCode: -2, detail: "URL can't be parsed: \(String(describing: url))")
    }

    /// Error that indicates that the response can't be parsed
    /// - Parameter description:  is the description of the error
    /// - Returns: NetworkAPIError
    static func parseError(_ description: String) -> NetworkAPIError {
        NetworkAPIError(statusCode: -3, detail: description)
    }
}

// MARK: - APIError
extension NetworkAPIError: APIError {
    // Silent is golden
}
