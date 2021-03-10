//
//  EndPointType.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

/// HTTPMethodTypes
enum HTTPMethod: String {
    // implement more when needed: post, put, delete etc.
    case get = "GET"
}

/// Protocol to which every Api service should confirm to
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: String]? { get}
    var method: HTTPMethod { get }
}
