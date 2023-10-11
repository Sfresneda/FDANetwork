//
//  File.swift
//  
//
//  Created by Sergio Fresneda on 11/10/23.
//

@testable import FDANetwork
import Foundation

struct NetworkSessionMock {
    var data: [String: Any]?
    var response: URLResponse?
    var error: (any APIError)?
}

extension NetworkSessionMock: NetworkSession {
    func data(for request: URLRequest,
              delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        guard let data, let response else {
            throw NetworkAPIError(statusCode: -5, detail: "unknown")
        }
        return (data.asJson!, response)
    }

    func upload(for request: URLRequest,
                from bodyData: Data,
                delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        guard let data, let response else {
            throw NetworkAPIError(statusCode: -5, detail: "unknown")
        }
        return (data.asJson!, response)
    }
}
