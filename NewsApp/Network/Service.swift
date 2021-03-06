//
//  Service.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

/// HTTPMethodTypes
enum HTTPMethod:String {
    // implement more when needed: post, put, delete etc.
    case get = "GET"
}

/// Protocol to which every Api service should confirm to
protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get}
    var method: HTTPMethod { get }
}

extension Service {
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    public var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        switch method {
        case .get:
        // add query items to url
            guard let parameters = parameters as? [String:String] else {
                fatalError("parameters for GET http method must conform to [String: String]")
            }
            urlComponents?.queryItems = parameters.map {URLQueryItem(name: $0.key, value: $0.value)}
        }
        
        return urlComponents?.url
    }
}
