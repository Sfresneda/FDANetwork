//
//  File.swift
//  
//
//  Created by Sergio Fresneda on 11/10/23.
//

@testable import FDANetwork
import Foundation

final class NetworkLoggerMock {
    var storedLogs: [LogModel] = []
}

extension NetworkLoggerMock: NetworkLogger {
    func log(category: FDANetwork.NetworkLoggerCategory, content: String...) {
        let model = LogModel(category: category, content: content)
        storedLogs.append(model)
    }
}

struct LogModel: Equatable {
    let category: NetworkLoggerCategory
    let content: [String]
}
