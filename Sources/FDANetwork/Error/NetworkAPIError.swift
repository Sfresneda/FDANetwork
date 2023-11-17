//
//  NetworkAPIError.swift
//
//  Created by Sergio Fresneda on 10/10/23.
//

import Foundation

/// Class that contains the error
struct NetworkAPIError {

    fileprivate enum DefaultError {
        case reset
        case noResponse
        case badUrl(String)
        case parseError(String)
        
        var statusCode: Int {
            switch self {
            case .reset: return 0
            case .noResponse: return -1
            case .badUrl: return -2
            case .parseError: return -3
            }
        }

        var description: Any {
            switch self {
            case .reset:
                return "App needs to reset"
            case .noResponse:
                return "No response"
            case .badUrl(let url):
                return "URL can't be parsed: \(url))"
            case .parseError(let description):
                return description
            }
        }
    }

    /// Status code of the error
    let statusCode: Int

    /// Detail of the error
    let rawError: Any?

    /// Initializer of the struct with error description model
    init(statusCode: Int, rawError: Any?) {
        self.statusCode = statusCode
        self.rawError = rawError
    }
    private init(_ error: DefaultError) {
        self.init(statusCode: error.statusCode, rawError: error.description)
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
        .init(.reset)
    }

    /// Error that indicates that the network response has no response
    static var noResponse: NetworkAPIError {
        .init(.noResponse)
    }

    /// Error that indicates that the url is not valid
    static func badUrl(_ url: String) -> NetworkAPIError {
        .init(.badUrl(url))
    }

    /// Error that indicates that the response can't be parsed
    /// - Parameter description:  is the description of the error
    /// - Returns: NetworkAPIError
    static func parseError(_ description: String) -> NetworkAPIError {
        .init(.parseError(description))
    }
}

// MARK: - APIError
extension NetworkAPIError: APIError {
    // Silent is golden
}
