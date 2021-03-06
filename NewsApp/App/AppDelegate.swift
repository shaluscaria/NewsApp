//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let router = AppRouter(window: window)
        router.start()
        return true
    }

}
