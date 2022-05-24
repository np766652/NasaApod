//
//  NetworkError.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation

enum NetworkError: String {
    case noInternet
    case apiFailure
    case invalidResponse
    case decodingError
    case invalidURL
}
