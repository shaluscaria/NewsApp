//
//  SavedNewsViewModelProtocol.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-17.
//

import Foundation

enum SavedNewsViewModelOutput {
    case showTitle(String)
    case showSavedNews(News)
}

protocol SavedNewsViewModelProtocol {
    var delegate: SavedNewsViewModelDelegate? { get set}
    func fetchDataFromDisk()
    func removeData(at index: Int)
    func clearAllDataFromDisk()
}

protocol SavedNewsViewModelDelegate: class {
    func showViewModelOutput(_ output: SavedNewsViewModelOutput)
}
