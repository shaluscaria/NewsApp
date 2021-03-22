//
//  SavedNewsCell.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-21.
//

import UIKit

class SavedNewsCell: UITableViewCell {
    // MARK: - Property
    @IBOutlet private weak var newsImageView: UIImageView?
    @IBOutlet private weak var newsTitleLabel: UILabel?
    @IBOutlet private weak var newsFilterButton: UIButton?
    @IBOutlet private weak var publishedDateLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
    }
    
    func configureCell(_ indexPath: IndexPath, news: NewsElement) {
        newsImageView?.setImage(from: news.newsCoverImage)
        newsTitleLabel?.text =  news.newsTitle
        publishedDateLabel?.text = news.newsPostedDateString
        newsTitleLabel?.textColor = Constants.Color.primaryTextColor
        publishedDateLabel?.textColor = Constants.Color.primaryTextColor
    }
}
