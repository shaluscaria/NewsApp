//
//  News.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-06.
//

import UIKit

typealias News = [NewsElement]

public protocol NewsViewModel {
    var newsTitle: String { get }
    var newsCoverImage: String { get }
    var newsPostedDateString: String { get }
    var newsTypeFilter: String { get }
}

struct NewsElement: Codable, Hashable {
    let newsId: Int
    let title: String
    let publishedDate: String
    let type: String
    let typeAttributes: TypeAttributes
    
    static let newsID = ""
    
    enum CodingKeys: String, CodingKey {
        case newsId = "id"
        case title, type
        case publishedDate = "readablePublishedAt"
        case typeAttributes
    }
    
    static func == (lhs: NewsElement, rhs: NewsElement) -> Bool {
        return lhs.newsId == rhs.newsId
    }
    
}

struct TypeAttributes: Codable, Hashable {
    let coverImage: String
    
    enum CodingKeys: String, CodingKey {
        case coverImage = "imageLarge"
    }
}

extension NewsElement: Identifiable {
    var id: Int {
        return newsId
    }
}

extension NewsElement: NewsViewModel {
    var newsTitle: String {
        return self.title
    }
    
    var newsCoverImage: String {
        return self.typeAttributes.coverImage
    }
    
    var newsPostedDateString: String {
        var result = ""
        // Remove AM && PM as date string is not in appropriate satte
        var dateString = self.publishedDate.replacingOccurrences(of: "AM", with: "")
        dateString = dateString.replacingOccurrences(of: "PM", with: "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy, HH:mm:ss z"
        
        if let date = dateFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd "
            result = formatter.string(from: date)
        }
        return result
    }
    
    var newsTypeFilter: String {
        return self.type.capitalized
    }
    
}

private extension String {
    var canadianLocaleName: String { return self == "fr" ? "fr-ca" : "en-ca"}
}
