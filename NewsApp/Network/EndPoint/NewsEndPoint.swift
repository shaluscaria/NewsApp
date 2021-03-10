//
//  NewsService.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

/// confirms to protocol EndPointType
public enum NewsEndPoint {
    case newsItem(category: String)
}

extension NewsEndPoint: EndPointType {
    
    var environmentBaseURL: String {
        return ServiceConstants.baseURL
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .newsItem:
            return ServiceConstants.newsItemsAPI
        }
    }
    
    var parameters: [String: String]? {
        /// default params
        var params: [String: String] = ["categorySet": "cbc-news-apps",
                                    "typeSet": "cbc-news-apps-feed-v2",
                                    "excludedCategorySettttt": "cbc-news-apps-exclude",
                                    "page": "1",
                                    "pageSize": "20"]
        switch self {
        case .newsItem(let category):
            params["lineupSlug"] = category
        }
        return params
    }
    
    var method: HTTPMethod {
        switch self {
        case .newsItem:
            return .get
        }
    }
    
}
