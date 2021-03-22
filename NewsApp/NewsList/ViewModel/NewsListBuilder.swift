//
//  NewsListBuilder.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-06.
//

import UIKit

final class NewsListBuilder {
    
    static func make() -> NewsListViewController {
        let newsListVC = NewsListViewController.instantiateViewController(
                            with: Constants.StoryBoard.NewsList)
        let serviceProvider = ServiceProvider<NewsEndPoint>()
        
        newsListVC.viewModel = NewsListViewModel(serviceProvider: serviceProvider)
        return newsListVC
    }
}
