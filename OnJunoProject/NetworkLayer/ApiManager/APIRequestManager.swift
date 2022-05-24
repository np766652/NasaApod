//
//  ApiRequestManager.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation


fileprivate enum APIRequestManager: APIRequestProtocol {
        
    case getAPI(path: String, queries: [String: Any])

    static func makeRequest<U: Codable>(session: URLSession, request: URLRequest, model: U.Type, onCompletion: @escaping (U?, NetworkError?) -> ()) {
        session.dataTask(with: request) { data, response, error in
            guard error == nil, let responseData = data else {
                onCompletion(nil, NetworkError.apiFailure)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [[String: Any]] {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let parsedResponse = try JSONDecoder().decode(U.self, from: jsonData)
                    onCompletion(parsedResponse, nil)
                } else {
                    onCompletion(nil, NetworkError.invalidResponse)
                    return
                }
            } catch {
                onCompletion(nil, NetworkError.decodingError)
            }
        }.resume()
    }
    
    static func makeRequest<T: Codable>(path: String, queries: [String : Any], onCompletion: @escaping (T?, NetworkError?) -> ()) {
        let session = URLSession.shared
        guard let request: URLRequest = Self.getAPI(path: path, queries: queries).asURLRequest() else {
            onCompletion(nil, NetworkError.invalidURL)
            return
        }
        
        makeRequest(session: session, request: request, model: T.self, onCompletion: onCompletion)
    }
    
    private var path: String {
        switch self {
        case .getAPI(let path, _):
            return path
        }
    }
    
    private var method: HTTPMethods {
        switch self {
        case .getAPI:
            return .GET
        }
    }
    
    fileprivate func asURLRequest() -> URLRequest?  {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "baseURLString") as? String, let baseURL = URL(string: baseURLString) else {
            NSLog("BaseURL is inavlid")
            return nil
        }
        
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        
        switch self {
        case .getAPI(_, let queries):
            queryItems = queries.compactMap({URLQueryItem(name: $0, value: $1 as? String)})
            components?.queryItems = queryItems.sorted(by: {$0.name < $1.name})
            request.url = components?.url
        }
        return request
    }
    
}

struct NetworkManager {
    
    func getAPODList(queries: [String: Any], onCompletion: @escaping ([ApodResponse]?, NetworkError?) -> ()) {
        APIRequestManager.makeRequest(path: "planetary/apod", queries: queries, onCompletion: onCompletion)
    }
    
}
