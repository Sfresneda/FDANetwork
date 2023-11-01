//
//  NetworkRequestType.swift
//
//  Created by Sergio Fresneda on 2/11/23.
//

import Foundation

public enum NetworkRequestType: String, Equatable {
    /// GET request.
    case get
    /// POST request.
    case post
    /// PATCH request.
    case patch
    /// PUT request.
    case put
    /// DELETE request.
    case delete

    /// The HTTP method of the request.
    internal var httpRequestValue: String {
        rawValue
    }
}
