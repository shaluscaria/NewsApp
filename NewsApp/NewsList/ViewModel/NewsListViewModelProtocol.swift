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
}

protocol NewsListViewModelDelegate: class {
    func handleViewModelOutput(_ output: NewsListViewModelOutput)
}

enum NewsListViewModelOutput {
    case setTitle(String)
    case showNewsList(News)
    case showError(Error)
}
