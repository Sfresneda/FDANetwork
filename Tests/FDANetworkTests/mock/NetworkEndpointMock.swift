//
//  NetworkEnpoint.swift
//  
//
//  Created by Sergio Fresneda on 11/10/23.
//

@testable import FDANetwork
import Foundation

struct NetworkEndpointMock {
    var url: URL
}
extension NetworkEndpointMock: NetworkEndpoint {
    // Silent is golden
}
