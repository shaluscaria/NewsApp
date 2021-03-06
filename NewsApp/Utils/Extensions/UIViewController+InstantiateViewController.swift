//
//  UIViewController+InstantiateViewController.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import UIKit

extension UIViewController {
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard")
        }
        return viewController
    }
}
