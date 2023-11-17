//
//  NetworkRequestsExecutor.swift
//
//  Created by Sergio Fresneda on 2/9/23.
//

import Foundation

/// NetworkRequestsExecutor is a class that implements the NetworkExecutor protocol.
/// It is responsible for executing a network request.
public final class NetworkRequestsExecutor {
    /// The session used to execute the request.
    private var session: NetworkSession
    /// The logger used to log the request.
    private var logger: NetworkLogger?
    
    /// The cache policy for the request. Defaults to `.reloadIgnoringLocalAndRemoteCacheData`.
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    /// The timeout interval for the request. Defaults to 30 seconds.
    public var timeOut: TimeInterval = 30

    /// Initializes a new NetworkRequestsExecutor.
    /// - Parameter session: NetworkSessionWrap used to execute the request.
    /// - Parameter logger: NetworkLogger used to log the request.
    public init(session: NetworkSession, logger: NetworkLogger?) {
        self.session = session
        self.logger = logger
    }
}

// MARK: - NetworkExecutor
extension NetworkRequestsExecutor: NetworkExecutor {
    /// Executes a network request.
    /// - Parameter request: The request model to be executed.
    /// - Returns: A NetworkResponse with the response of the request.
    /// - Throws: An APIError if the request fails.
    public func execute<T: Decodable>(request: FDANetworkRequest) async throws -> NetworkResponse<T> {
        do {
            logger?.logPreparingRequest(request)

            let urlRequest = try buildRequest(for: request)
            return try await launchRequest(urlRequest)

        } catch {
            logger?.logThrowError(error)
            throw error
        }
    }
}

// MARK: - Private
private extension NetworkRequestsExecutor {
    /// Executes a network request. It is a private method that is called from the public method `execute`.
    /// - Parameter request: URLRequest to be executed.
    /// - Returns: NetworkResponse with the response of the request. It is a generic type.
    func launchRequest<T: Decodable>(_ request: URLRequest) async throws -> NetworkResponse<T> {
        let response = try await session.data(for: request, delegate: nil)
        logger?.logResponseReceived(response)

        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw NetworkAPIError.noResponse
        }

        try handleStatusCode(httpResponse.statusCode, extraData: response.0)

        let model = try JSONDecoder().decode(T.self, from: response.0)
        logger?.logResponseParsed(model)

        return model
    }

    /// Handles the status code of the response.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter extraData: Optional extra information about response.
    /// - Throws: An APIError if the status code is not valid.
    func handleStatusCode(_ statusCode: Int, extraData: Data?) throws {
        guard 300 <= statusCode else {
            return
        }

        var detail: String?

        if let extraData {
            detail = String(data: extraData, encoding: .utf8)
        }

        throw NetworkAPIError(statusCode: statusCode, rawError: detail)
    }
}

// MARK: - Helpers
private extension NetworkRequestsExecutor {
    /// Builds a URLRequest from a FDANetworkRequest.
    /// - Parameters:
    ///   - model: FDANetworkRequest used to build the URLRequest.
    /// - Returns: URLRequest built from the FDANetworkRequest and the FDANetworkRequest.
    func buildRequest(for model: FDANetworkRequest) throws -> URLRequest {
        let url = try model.url

        guard var queryItems = URLComponents(string: url.absoluteString),
              let url = queryItems.url else {
            throw NetworkAPIError.badUrl(url.absoluteString)
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: cachePolicy,
                                    timeoutInterval: timeOut)
        var bodyItems = URLComponents()

        buildHeaders(model.headers, request: &urlRequest)
        buildQueryItems(from: model.queryItems, components: &queryItems)
        buildQueryItems(from: model.body, components: &bodyItems)

        urlRequest.httpMethod = model.type.httpRequestValue
        urlRequest.httpBody = bodyItems.query?.data(using: .utf8)

        logger?.logCreatedRequest(urlRequest)

        return urlRequest
    }

    /// Builds an array of URLQueryItem from a FDANetworkRequest.
    /// - Parameters:
    ///  - params: Dictionary of parameters to be added to the URLQueryItem array.
    ///  - components: URLComponents used to build the URLQueryItem array.
    func buildQueryItems(from params: [String : Any]?, components: inout URLComponents) {
        guard let params else { return }

        components.queryItems = params
            .mapValues { $0 as Any }
            .map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }

    /// Builds an array of HTTPHeaders from a FDANetworkRequest.
    /// - Parameters:
    ///  - headers: Dictionary of headers to be added to the HTTPHeaders array.
    ///  - request: URLRequest used to build the HTTPHeaders array.
    func buildHeaders(_ headers: [String: String]?, request: inout URLRequest) {
        guard let headers else { return }

        headers.forEach { headerPair in
            request.addValue(headerPair.value, forHTTPHeaderField: headerPair.key)
        }
    }
}
