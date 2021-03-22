//
//  SavedNewsBuilder.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-17.
//

import UIKit

final class SavedNewsBuilder {
    
    static func make(with viewModel: SavedNewsViewModel) -> SavedNewsViewController {
        let savedNewsVC = SavedNewsViewController.instantiateViewController(with: Constants.StoryBoard.SavedNews)
        savedNewsVC.viewModel = viewModel
        return savedNewsVC
    }
}
