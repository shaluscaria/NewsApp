//
//  SavedListViewModel.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-21.
//

import Foundation

class SavedNewsViewModel: SavedNewsViewModelProtocol {
    
    weak var delegate: SavedNewsViewModelDelegate?
    private let cache  = Cache<NewsElement.ID, [NewsElement]>()
    let newsId = NewsElement.ID()
    
    func fetchDataFromDisk() {
        self.delegate?.showViewModelOutput(.showTitle("Saved News"))
        let news = self.retrieveDataFromDisk(Constants.FilePath.savedNewsFilePath, for: newsId )
        if let news = news {
            self.delegate?.showViewModelOutput(.showSavedNews(news))
        }
    }
    
    func removeData(at index: Int) {
        var newsList: [NewsElement] = []
        let retrievedNews = retrieveDataFromDisk(Constants.FilePath.savedNewsFilePath, for: newsId)
        
        if let retrievedNews = retrievedNews {
            newsList.append(contentsOf: retrievedNews)
        }
        
        newsList.remove(at: index)
       
        let cache = Cache<NewsElement.ID, [NewsElement]>()
        cache[self.newsId] = newsList.map {$0}
        cache.saveToDisk(with: Constants.FilePath.savedNewsFilePath)
    }
    
    func clearAllDataFromDisk() {
        self.cache.removeValue(forKey: newsId)
        self.cache.saveToDisk(with: Constants.FilePath.savedNewsFilePath)
    }
    
}

// MARK: - Private methods
private extension SavedNewsViewModel {
    func retrieveDataFromDisk(_ fileName: String, for key: NewsElement.ID) -> [NewsElement]? {
        let newsList = self.cache.retrieveFromDisk(fileName, forKey: key)
        guard let news = newsList  else {
            return nil
        }
        return news
    }
}
