//
//  ExampleModel.swift
//  
//
//  Created by Sergio Fresneda on 11/10/23.
//

import Foundation

struct ExampleModel: Codable, Equatable {
    var id: Int
    var name: String
}
extension ExampleModel {
    var asDictionary: [String: Any] {
        [
            "id": id,
            "name": name
        ]
    }
}
