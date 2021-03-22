//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

class NewsListViewModel: NewsListViewModelProtocol {
    // MARK: - properties
    weak var delegate: NewsListViewModelDelegate?
    private let serviceProvider: ServiceProvider<NewsEndPoint>
    private let cache  = Cache<NewsElement.ID, [NewsElement]>()
    let newsId = NewsElement.ID()
    
    init(serviceProvider: ServiceProvider<NewsEndPoint>) {
        self.serviceProvider = serviceProvider
    }
    
    func fetch() {
        self.delegate?.handleViewModelOutput(.setTitle("News"))
        serviceProvider.load(endPoint: .newsItem(category: "news"), decodeType: News.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case.failure(let error):
                print("Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.delegate?.handleViewModelOutput(.showError(error))
                }
            case .success(let newsResponse):
                // Caching news element
                let news = newsResponse
                self.cache[self.newsId] = news.map {$0}
                self.cache.saveToDisk(with: Constants.FilePath.newsListFilePath)
                self.delegate?.handleViewModelOutput(.showNewsList(newsResponse))
            }
        }
    }
    
    func retrieveData() {
        self.delegate?.handleViewModelOutput(.setTitle("News"))
        let newsList = retrieveDataFromDisk(Constants.FilePath.newsListFilePath, for: newsId)
        guard let news = newsList  else {
            return
        }
        self.delegate?.handleViewModelOutput(.showNewsList(news))
    }
    
    // Save news to separate file to load in Saved News
    func saveNewsToDisk(_ news: NewsElement) {
        // get saved news if any
        var newsList: [NewsElement] = []
        let retrievedNews = retrieveDataFromDisk(Constants.FilePath.savedNewsFilePath, for: newsId)
        
        if let retrievedNews = retrievedNews {
            newsList.append(contentsOf: retrievedNews)
        }
        
        if !newsList.contains(news) {
            newsList.append(news)
        }
       
        let cache = Cache<NewsElement.ID, [NewsElement]>()
        cache[self.newsId] = newsList.map {$0}
        cache.saveToDisk(with: Constants.FilePath.savedNewsFilePath)
    }
    
}

// MARK: - Private Methods
private extension NewsListViewModel {
    func retrieveDataFromDisk(_ fileName: String, for key: NewsElement.ID) -> [NewsElement]? {
        let newsList = self.cache.retrieveFromDisk(fileName, forKey: key)
        guard let news = newsList  else {
            return nil
        }
        return news
    }
}
