//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

class NewsListViewModel {
    let service: NewsService
    var news: News?
    
    init(service: NewsService) {
        self.service = service
    }
    
    func fetch(){
        
    }
}
