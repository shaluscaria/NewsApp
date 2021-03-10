//
//  AppRouter.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import UIKit

final class AppRouter {
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let rootViewController = NewsListBuilder.make()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
}
