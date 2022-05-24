//
//  Encodable+Dictionary.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation

/**
     Converts Encodable objects into dictionary
    - returns: [String: Any]?.
*/
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
