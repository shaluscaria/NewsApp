//
//  UIViewController+Ext.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-06.
//

import UIKit

// MARK: - instantiate viewcontrollers from storyboard
extension UIViewController {
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard")
        }
        return viewController
    }
}

// MARK: - show alert
extension UIViewController {
    func showAlert(title: String, message: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
