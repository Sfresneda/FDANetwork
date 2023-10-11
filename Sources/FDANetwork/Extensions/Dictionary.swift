//
//  Dictionary.swift
//
//  Created by Sergio Fresneda on 11/10/23.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    var asJson: Data? {
        try? JSONEncoder().encode(self)
    }
}
extension Dictionary where Key == String, Value == Any {
    var asJson: Data? {
        try? JSONSerialization.data(withJSONObject: self)
    }
}
