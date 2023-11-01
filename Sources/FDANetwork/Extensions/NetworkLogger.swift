//
//  NetworkLogger.swift
//
//  Created by Sergio Fresneda on 11/10/23.
//

import Foundation

extension NetworkLogger {
    /// Log the request preparing
    /// - Parameter model: FDANetworkRequest, the model of the request
    func logPreparingRequest(_ model: FDANetworkRequest) {
        let content = """
        [PREPARING REQUEST][NETWORK MODEL]
        - Headers: \(String(describing: model.headers))
        - Query Params: \(String(describing: model.queryItems))
        - Body: \(String(describing: model.body))
        - Request: \(model.type.httpRequestValue)
        """

        logDb(content: content)
    }

    /// Log the request preparing
    /// - Parameter request: URLRequest, the request
    func logCreatedRequest(_ request: URLRequest) {
        let content = """
        [CREATED REQUEST][NETWORK REQUEST]
        - URL: \(String(describing: request.url?.absoluteString))
        - Method: \(String(describing: request.httpMethod))
        - Headers: \(String(describing: request.allHTTPHeaderFields))
        - Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "-")
        """

        logI(content: content)
    }

    /// Log the response received
    /// - Parameter response: (data: Data, response: URLResponse), the response
    func logResponseReceived(_ response: (data: Data, response: URLResponse)) {
        let unwrapResponse = response.response as? HTTPURLResponse
        let content = """
        [RESPONSE RECEIVED][RESPONSE]
        - Data: \(String(data: response.data, encoding: .utf8) ?? "-")
        - Response:
        - URL: \(String(describing: response.response.url?.absoluteString))
        - Status code: \(String(describing: unwrapResponse?.statusCode))
        """

        logI(content: content)
    }

    /// Log the response parsed
    /// - Parameter model: Decodable, the model of the response
    func logResponseParsed(_ model: Decodable) {
        let content = """
        [RESPONSE PARSED][MODEL]
        - Representation: \(String(describing: model))
        """

        logDb(content: content)
    }

    /// Log the error throw
    /// - Parameter error: Error, the error
    func logThrowError(_ error: Error, context: String = #function) {
        var content: String = ""
        if let apiError = error as? (any APIError) {
            content = """
            [ERROR THROW][APIERROR]
            - Error code: \(apiError.statusCode)
            - Localized Description: \(apiError.localizedDescription)
            """
        } else {
            content = """
            [ERROR THROW][ERROR]
            - Localized Description: \(error.localizedDescription)
            """
        }

        logE(content: content)
    }
}

// MARK: - Log method helpers
fileprivate extension NetworkLogger {

    /// Log the content in debug mode
    /// - Parameter content: String, the content to log
    func logDb(content: String) {
        log(category: .debug,
            content: contentBuilder(content, category: .debug))
    }

    /// Log the content in info mode
    /// - Parameter content: String, the content to log
    func logI(content: String) {
        log(category: .info,
            content: contentBuilder(content, category: .debug))
    }

    /// Log the content in default mode
    /// - Parameter content: String, the content to log
    func logDf(content: String) {
        log(category: .default,
            content: contentBuilder(content, category: .debug))
    }

    /// Log the content in error mode
    /// - Parameter content: String, the content to log
    func logE(content: String) {
        log(category: .error,
            content: contentBuilder(content, category: .debug))
    }

    /// Log the content in fault mode
    /// - Parameter content: String, the content to log
    func logF(content: String) {
        log(category: .fault,
            content: contentBuilder(content, category: .debug))
    }
}

// MARK: - Message builder helpers
fileprivate extension NetworkLogger {

    /// Prefix of the log
    var logPrefix: String {
        "[\(Date().completeCurrentTimeFormattedString)][FDANetwork] -"
    }

    /// Suffix of the log
    var logSuffix: String {
        "- [🌍]"
    }

    /// Build the content of the log
    func contentBuilder(_ content: String, category: NetworkLoggerCategory) -> String {
        "[\(category.visualRepresentation)]\(logPrefix)\(content)\(logSuffix)"
    }
}
