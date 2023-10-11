//
//  NetworkEndpointExecutor.swift
//
//  Created by Sergio Fresneda on 2/9/23.
//

import Foundation

/// NetworkEndpointExecutor is a class that implements the NetworkExecutor protocol.
/// It is responsible for executing a network request.
public final class NetworkEndpointExecutor {
    /// The session used to execute the request.
    private var session: NetworkSession
    /// The logger used to log the request.
    private var logger: NetworkLogger?
    
    /// The cache policy for the request. Defaults to `.reloadIgnoringLocalAndRemoteCacheData`.
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    /// The timeout interval for the request. Defaults to 30 seconds.
    public var timeOut: TimeInterval = 30

    /// Initializes a new NetworkEndpointExecutor.
    /// - Parameter session: NetworkSessionWrap used to execute the request.
    /// - Parameter logger: NetworkLogger used to log the request.
    public init(session: NetworkSession, logger: NetworkLogger?) {
        self.session = session
        self.logger = logger
    }
}

// MARK: - NetworkExecutor
extension NetworkEndpointExecutor: NetworkExecutor {
    /// Executes a network request.
    /// - Parameter requestModel: The request model to be executed.
    /// - Returns: A NetworkResponse with the response of the request.
    /// - Throws: An APIError if the request fails.
    public func execute<T: Decodable>(requestModel: NetworkRequestModel) async throws -> NetworkResponse<T> {
        do {
            logger?.logPreparingRequest(requestModel)

            switch requestModel.request {
            case .get(let endpoint):
                let urlRequest = try buildRequest(for: requestModel, endpoint: endpoint)
                return try await launchRequest(urlRequest)

            case .post(let endpoint):
                let urlRequest = try buildRequest(for: requestModel, endpoint: endpoint)
                return try await launchRequest(urlRequest)

            case .patch(let endpoint):
                let urlRequest = try buildRequest(for: requestModel, endpoint: endpoint)
                return try await launchRequest(urlRequest)

            case .put(let endpoint):
                let urlRequest = try buildRequest(for: requestModel, endpoint: endpoint)
                return try await launchRequest(urlRequest)

            case .delete(let endpoint):
                let urlRequest = try buildRequest(for: requestModel, endpoint: endpoint)
                return try await launchRequest(urlRequest)
            }

        } catch {
            logger?.logThrowError(error)
            throw error
        }
    }
}

// MARK: - Private
private extension NetworkEndpointExecutor {
    /// Executes a network request. It is a private method that is called from the public method `execute`.
    /// - Parameter request: URLRequest to be executed.
    /// - Returns: NetworkResponse with the response of the request. It is a generic type.
    func launchRequest<T: Decodable>(_ request: URLRequest) async throws -> NetworkResponse<T> {
        do {
            let response = try await session.data(for: request, delegate: nil)
            logger?.logResponseReceived(response)

            guard let httpResponse = response.1 as? HTTPURLResponse else {
                throw NetworkAPIError.noResponse
            }

            try handleStatusCode(httpResponse.statusCode, extraData: response.0)

            let model = try JSONDecoder().decode(T.self, from: response.0)
            logger?.logResponseParsed(model)

            return model

        } catch DecodingError.dataCorrupted(let context) {
            let error = DecodingError.dataCorrupted(context)
            let description = String(describing: error.errorDescription)
            throw NetworkAPIError.parseError(description)
        }
    }

    /// Handles the status code of the response.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter extraData: Optional extra information about response.
    /// - Throws: An APIError if the status code is not valid.
    func handleStatusCode(_ statusCode: Int, extraData: Data?) throws {
        guard 300 <= statusCode else {
            return
        }

        guard let extraData else {
            return
        }

        let extraDetail = try JSONDecoder().decode(NetworkAPIErrorDetail.self, from: extraData)
        throw NetworkAPIError(statusCode: statusCode, errorDescription: extraDetail)
    }
}

// MARK: - Helpers
private extension NetworkEndpointExecutor {
    /// Builds a URLRequest from a NetworkRequestModel and a NetworkEndpoint.
    /// - Parameters:
    ///   - model: NetworkRequestModel used to build the URLRequest.
    ///   - endpoint: NetworkEndpoint used to build the URLRequest.
    /// - Returns: URLRequest built from the NetworkRequestModel and the NetworkEndpoint.
    func buildRequest(for model: NetworkRequestModel, endpoint: NetworkEndpoint) throws -> URLRequest {
        guard var queryItems = URLComponents(string: endpoint.url.absoluteString),
              let url = queryItems.url else {
            throw NetworkAPIError.badUrl(endpoint.url.absoluteURL)
        }

        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeOut)
        var bodyItems = URLComponents()

        buildHeaders(model.headers, request: &urlRequest)
        buildQueryItems(from: model.params, components: &queryItems)
        buildQueryItems(from: model.body, components: &bodyItems)

        urlRequest.httpMethod = model.request.httpRequestValue
        urlRequest.httpBody = bodyItems.query?.data(using: .utf8)

        logger?.logCreatedRequest(urlRequest)

        return urlRequest
    }

    /// Builds an array of URLQueryItem from a NetworkRequestModel.
    /// - Parameters:
    ///  - params: Dictionary of parameters to be added to the URLQueryItem array.
    ///  - components: URLComponents used to build the URLQueryItem array.
    func buildQueryItems(from params: [String : Any]?, components: inout URLComponents) {
        guard let params else { return }

        components.queryItems = params
            .mapValues { $0 as Any }
            .map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }

    /// Builds an array of HTTPHeaders from a NetworkRequestModel.
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
