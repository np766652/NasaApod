//
//  ApodResponse.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation

public struct ApodResponse: Codable {
    
    public var date: String?
    public var description: String?
    public var mediaType: String?
    public var title: String?
    public var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case date
        case description = "explanation"
        case mediaType = "media_type"
        case title
        case url
    }
}


