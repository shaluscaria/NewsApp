//
//  NewsListViewModelProtocol.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-06.
//

import UIKit

protocol NewsListViewModelProtocol {
    var delegate: NewsListViewModelDelegate? { get set}
    func fetch()
    func retrieveData()
    func saveNewsToDisk(_ news: NewsElement)
}

protocol NewsListViewModelDelegate: class {
    func handleViewModelOutput(_ output: NewsListViewModelOutput)
    func navigate(to navigationType: NavigationType)
}

enum NewsListViewModelOutput {
    case setTitle(String)
    case showNewsList(News)
    case showError(Error)
}

enum NavigationType {
    case savedNews
}
