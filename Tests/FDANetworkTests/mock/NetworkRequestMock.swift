//
//  NetworkEnpoint.swift
//  
//
//  Created by Sergio Fresneda on 11/10/23.
//

@testable import FDANetwork
import Foundation

struct NetworkRequestMock {
    var _url: String
    var _type: NetworkRequestType = .get
    var _headers: [String: String]?
    var _queryItems: [String: Any]?
    var _body: [String: Any]?
    let urlError: NSError = NSError(domain: "not.valid.url", code: 123)

    init(url: String, type: NetworkRequestType) {
        self._url = url
        self._type = type
    }
}
extension NetworkRequestMock: FDANetworkRequest {
    var url: URL {
        get throws {
            guard let url = URL(string: _url) else {
                throw urlError
            }
            return url
        }
    }
    
    var type: NetworkRequestType {
        _type
    }

    var headers: [String : String]? {
        _headers
    }

    var queryItems: [String : Any]? {
        _queryItems
    }

    var body: [String : Any]? {
        _body
    }
}
