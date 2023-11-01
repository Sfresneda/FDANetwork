//
//  FDANetwork.swift
//
//  Created by Sergio Fresneda on 11/10/23.
//

import Foundation

// MARK: - NetworkExecutor

/// NetworkResponse is a typealias for the Decodable response of a network request.
public typealias NetworkResponse<T: Decodable> = (T)

/// NetworkExecutor is a protocol that defines the methods that a NetworkExecutor must implement.
public protocol NetworkExecutor {
    /// The cache policy for the request. Defaults to `.reloadIgnoringLocalAndRemoteCacheData`.
    var cachePolicy: URLRequest.CachePolicy { get set }

    /// The timeout interval for the request. Defaults to 30 seconds.
    var timeOut: TimeInterval { get set }

    /// Executes a network request.
    /// - Parameter request: The request to be executed.
    /// - Returns: A NetworkResponse with the response of the request.
    func execute<T: Decodable>(request: FDANetworkRequest) async throws -> NetworkResponse<T>
}


// MARK: - FDANetworkRequest

/// FDANetworkRequest is a protocol that defines the properties that a FDANetworkRequest must implement.
public protocol FDANetworkRequest {
    var type: NetworkRequestType { get }
    var headers: [String: String]? { get }
    var queryItems: [String: Any]? { get }
    var body: [String: Any]? { get }
    var url: URL { get throws }
}

// MARK: - NetworkLogger

/// NetworkLogger is a protocol that defines the methods that a NetworkLogger must implement.
public protocol NetworkLogger {
    func log(category: NetworkLoggerCategory, content: String...)
}

/// NetworkLogger is a class that implements the NetworkLogger protocol.
public enum NetworkLoggerCategory: Equatable {
    case debug
    case info
    case `default`
    case error
    case fault

    /// The visual representation of the category.
    internal var visualRepresentation: String {
        switch self {
        case .debug:
            return "🟢"
        case .info:
            return "🔵"
        case .default:
            return "⚪️"
        case .error:
            return "🔴"
        case .fault:
            return "🟠"
        }
    }
}

// MARK: - APIError

/// APIError is a protocol that defines the properties that an APIError must implement.
public protocol APIError: LocalizedError, Equatable {
    var statusCode: Int { get }
    var localizedDescription: String { get }
}

// MARK: - NetworkSession

/// NetworkSession is a protocol that defines the methods that a NetworkSession must implement.
public protocol NetworkSession {
    /// Executes a network request. It returns the data and the response of the request.
    /// - Parameters:
    ///   - request: URLRequest to be executed.
    ///   - delegate: URLSessionTaskDelegate used to execute the request.
    /// - Returns: Tuple with the data and the response of the request.
    func data(for request: URLRequest,
              delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)

    /// Executes a network request. It returns the data and the response of the request.
    /// - Parameters:
    ///   - request: URLRequest to be executed.
    ///   - bodyData: Data to be sent in the request body.
    ///   - delegate: URLSessionTaskDelegate used to execute the request.
    /// - Returns: Tuple with the data and the response of the request.
    func upload(for request: URLRequest,
                from bodyData: Data,
                delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}
