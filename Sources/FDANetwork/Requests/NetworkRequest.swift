//
//  NetworkRequest.swift
//
//  Created by Sergio Fresneda on 3/9/23.
//

import Foundation

/// NetworkRequestModel is a struct that defines the properties of a network request.
public struct NetworkRequestModel {

    /// The request to be executed.
    let request: NetworkRequest

    /// The headers of the request.
    let body: [String: Any]?

    /// The parameters of the request.
    let params: [String: Any]?

    /// The headers of the request.
    let headers: [String: String]?
}

/// NetworkRequest is an enum that defines the possible network requests.
public enum NetworkRequest {
    /// GET request.
    case get(endpoint: NetworkEndpoint)
    /// POST request.
    case post(endpoint: NetworkEndpoint)
    /// PATCH request.
    case patch(endpoint: NetworkEndpoint)
    /// PUT request.
    case put(endpoint: NetworkEndpoint)
    /// DELETE request.
    case delete(endpoint: NetworkEndpoint)

    /// The HTTP method of the request.
    internal var httpRequestValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
