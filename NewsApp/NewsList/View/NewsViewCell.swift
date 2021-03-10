//
//  NewsViewCell.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-09.
//

import UIKit
import Foundation

protocol NewsViewCellDelegate: class {
    func filterNewsBy(filter filterType: String)
}

class NewsViewCell: UICollectionViewCell {
    
    weak var delegate: NewsViewCellDelegate?
    var news: NewsElement?
    
    @IBOutlet weak var coverImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var postedDateLabel: UILabel?
    @IBOutlet weak var typeFilterButton: UIButton?
    
    @IBAction func filterOnButtonClick(_ sender: UIButton) {
        if let news = self.news {
            delegate?.filterNewsBy(filter: news.newsTypeFilter)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.autoresizingMask = .flexibleHeight
    }
    
    func configureCell(with news: NewsElement, indexPath: IndexPath, state: VCState) {
        self.news = news
        setImage(from: news.newsCoverImage)
        titleLabel?.text =  news.newsTitle
        postedDateLabel?.text = news.newsPostedDateString
        titleLabel?.textColor = Constants.Color.primaryTextColor
        postedDateLabel?.textColor = Constants.Color.primaryTextColor
        typeFilterButton?.setTitle(news.newsTypeFilter, for: .normal)
        
        if state == .normal {
            self.typeFilterButton?.isHidden = false
        } else {
            self.typeFilterButton?.isHidden = true
        }
        
    }
    
}

// MARK: - Private Methods
private extension NewsViewCell {
    
    private func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.coverImageView?.image = image
            }
        }
    }
}
