//
//  NetworkRequest.swift
//  
//  Created by Sergio Fresneda on 2/11/23.
//

import Foundation

// MARK: - Network Request
/// NetworkRequest is an enum that defines the possible network requests.
public final class FDARequest {
    public let type: NetworkRequestType

    private var routeComponents: [String]
    private var _baseUrl: String?
    private var _headers: [String: String]?
    private var _queryItems: [String: Any]?
    private var _body: [String: Any]?

    internal init(type: NetworkRequestType, routeComponents: [String]) {
        self.type = type
        self.routeComponents = routeComponents
    }
}

extension FDARequest: FDANetworkRequest {
    public var headers: [String : String]? {
        _headers
    }

    public var queryItems: [String : Any]? {
        _queryItems
    }

    public var body: [String : Any]? {
        _body
    }

    public var url: URL {
        get throws {
            let unwrappedBaseUrl = _baseUrl ?? ""
            let joinedPath = routeComponents.joined(separator: "/")
            let rawUrl = unwrappedBaseUrl + joinedPath
            let url = URL(string: rawUrl)

            guard let url else {
                throw NetworkAPIError.badUrl(rawUrl)
            }

            return url
        }
    }
}

public extension FDARequest {
    static func get(_ routeComponents: String...) -> FDARequest {
        .init(type: .get, routeComponents: routeComponents)
    }

    static func post(_ routeComponents: String...) -> FDARequest {
        .init(type: .post, routeComponents: routeComponents)
    }

    static func patch(_ routeComponents: String...) -> FDARequest {
        .init(type: .patch, routeComponents: routeComponents)
    }

    static func put(_ routeComponents: String...) -> FDARequest {
        .init(type: .put, routeComponents: routeComponents)
    }

    static func delete(_ routeComponents: String...) -> FDARequest {
        .init(type: .delete, routeComponents: routeComponents)
    }
}

public extension FDARequest {
    func baseUrl(_ baseUrl: String) -> Self {
        _baseUrl = baseUrl
        return self
    }

    func headers(_ headers: [String: String]) -> Self {
        _headers = headers
        return self
    }

    func queryItems(_ queryItems: [String: Any]) -> Self {
        _queryItems = queryItems
        return self
    }

    func body(_ body: [String: Any]) -> Self {
        _body = body
        return self
    }
}
