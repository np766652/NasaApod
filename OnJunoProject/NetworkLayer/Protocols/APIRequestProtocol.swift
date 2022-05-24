//
//  ServiceType.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation

protocol APIRequestProtocol {
    static func makeRequest<U: Codable>(session: URLSession, request: URLRequest, model: U.Type, onCompletion:
                                        @escaping(U?, NetworkError?) -> ())
    
    static func makeRequest<T: Codable>(path: String, queries: [String: Any],
                                        onCompletion: @escaping(T?, NetworkError?) -> ())
}
