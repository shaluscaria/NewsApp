//
//  Constants.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-09.
//

import UIKit

struct Constants {
    
    struct Color {
        static let primaryRedColor = UIColor(red: 230.0 / 255.0,
                                             green: 6.0 / 255.0,
                                             blue: 6.0 / 255.0,
                                             alpha: 1.0)
        static let backgroundColor = UIColor.darkGray
        static let primaryTextColor = UIColor.white
        
    }
    
    struct FilePath {
        static let newsListFilePath = "NewsList.json"
        static let savedNewsFilePath = "SavedNewsList.json"
    }
    
    struct ViewCells {
        static let savedNewsCell = "SavedNewsCell"
    }
    
    struct StoryBoard {
        static let NewsList = "NewsList"
        static let SavedNews = "SavedNews"
    }
    
    struct SavedNews {
        static let emptyCellTitle = "No Saved News Available"
    }
    
}
