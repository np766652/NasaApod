//
//  ApodRequestParams.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation


public struct ApodRequestParams: Codable {
    
    public var count: String
    public var apiKey: String
    
    public init(count: String, apiKey: String) {
        self.count = count
        self.apiKey = apiKey
    }

    private enum CodingKeys: String, CodingKey {
        case count
        case apiKey = "api_key"
    }
}


