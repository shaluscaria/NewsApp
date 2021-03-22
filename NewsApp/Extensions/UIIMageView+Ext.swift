//
//  UIIMageView+Ext.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-22.
//

import UIKit

// MARK: - Set Image from URL
extension UIImageView {
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
