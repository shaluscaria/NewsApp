//
//  NewsService.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

/// This Servcie holds all APIs related to News
enum NewsService {
    case newsItem(category : String)
}

extension NewsService: Service {
    var baseURL: String {
        return ServiceConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .newsItem(_):
            return ServiceConstants.newsItemsAPI
        }
    }
    
    var parameters: [String : Any]? {
        /// FIXME:- fix default params
        /// default params
        var params:[String:Any] = ["categorySet":"cbc-news-apps","typeSet":"cbc-news-apps-feed-v2","excludedCategorySet":"cbc-news-apps-exclude","page":1,"pageSize":20]
        switch self {
        case .newsItem(let category):
            params["lineupSlug"] = category
        }
        return params
    }
    
    var method: HTTPMethod {
        switch self {
        case .newsItem(_):
            return .get
        }
    }
    
    
}




