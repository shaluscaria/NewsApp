//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import UIKit

enum LayoutStyle {
    case potrait
    case landscape
}

enum VCState {
    case normal
    case filtered
}

class NewsListViewController: UIViewController {
    // MARK: - Property
    @IBOutlet weak var newsCollectionView: UICollectionView?
    
    var viewModel: NewsListViewModelProtocol?
    var news: News?
    var layoutStyle: LayoutStyle = .potrait
    var state: VCState = .normal
    var filteredNews = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        checkInternetConnection()
        setUpCollectionView()
        setLayoutSwitch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyConnectionChanges),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - NewsListViewModelDelegate delegate methods
extension NewsListViewController: NewsListViewModelDelegate {
    func handleViewModelOutput(_ output: NewsListViewModelOutput) {
        DispatchQueue.main.async {
            switch output {
            case .setTitle(let title):
                self.setUpNavigationBar(title: title)
            case .showNewsList(let news):
                self.news = news
                self.newsCollectionView?.reloadData()
            case .showError(let error):
                self.showAlert(title: "Error", message: error.localizedDescription, actions: nil)
            }
        }
    }
}

// MARK: - Private methods
private extension NewsListViewController {
    
    func setLayoutSwitch() {
        let image = UIImage(named: "layoutIcon")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(changeLayout))
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.primaryTextColor
    }
    
    func setUpCollectionView() {
        self.registerNib()
        self.newsCollectionView?.delegate = self
        self.newsCollectionView?.dataSource = self
    }
    
    func registerNib() {
        self.newsCollectionView?.register(UINib(nibName: "NewsViewCell",
                                                bundle: nil),
                                 forCellWithReuseIdentifier: "NewsViewCell")
    }
    
    func checkInternetConnection() {
        if InternetConnectionManager.isConnectedToNetwork() {
            viewModel?.fetch()
        } else {
            viewModel?.retrieveData()
            showAlert(title: "Offline", message: "No network Connection", actions: nil)
        }
    }
    
    func setUpNavigationBar(title: String) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barStyle = .default
        
        self.navigationController?.navigationBar.barTintColor = Constants.Color.primaryRedColor
        let textAttribute = [NSAttributedString.Key.foregroundColor: Constants.Color.primaryTextColor]
            self.navigationController?.navigationBar.titleTextAttributes = textAttribute
    }
    
}

// MARK: -
extension NewsListViewController {
    @objc func changeLayout() {
        switch layoutStyle {
        case .potrait:
            layoutStyle = .landscape
        case .landscape:
            layoutStyle = .potrait
        }
        self.newsCollectionView?.reloadData()
    }
    
    @objc func cancelFilter() {
        self.state = .normal
        setLayoutSwitch()
        self.newsCollectionView?.reloadData()
    }
    
    @objc func notifyConnectionChanges() {
        checkInternetConnection()
    }
}

// MARK: - CollectionView Delegate
extension NewsListViewController: UICollectionViewDelegate {
    
}

extension NewsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .normal:
            guard let count = self.news?.count else { return 0 }
            return count
        case.filtered:
            return filteredNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell",
                                                         for: indexPath) as? NewsViewCell,
           let news = self.news {
            
            switch state {
            case .normal:
                cell.configureCell(with: news[indexPath.row],
                                   indexPath: indexPath,
                                   state: .normal)
            case .filtered:
                cell.configureCell(with: self.filteredNews[indexPath.row],
                                   indexPath: indexPath,
                                   state: .filtered)
            }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - CollectionView FlowDelegate
extension NewsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch layoutStyle {
        // Following dynamic height
        case .potrait:
            if let sizingCell = Bundle.main.loadNibNamed("NewsViewCell",
                                                         owner: self,
                                                         options: nil)?.first as? NewsViewCell,
               let news = self.news {
                sizingCell.configureCell(with: news[indexPath.row], indexPath: indexPath, state: .normal)
                sizingCell.setNeedsLayout()
                sizingCell.layoutIfNeeded()
                width = collectionView.bounds.width  - (Constants.NewsCell.minSpacing * 2)
                height = sizingCell.systemLayoutSizeFitting(CGSize(width: width,
                                                                   height: .infinity),
                                            withHorizontalFittingPriority: UILayoutPriority.required,
                                            verticalFittingPriority: UILayoutPriority.fittingSizeLevel).height
            }
        case .landscape:
            // Fixed height
            width = (collectionView.bounds.width  - Constants.NewsCell.minSpacing * 2) / 2
            height = Constants.NewsCell.cellHeightInLandscape
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch layoutStyle {
        case .potrait:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .landscape:
            return UIEdgeInsets(top: 0, left: Constants.NewsCell.minSpacing / 2,
                                bottom: 0, right: Constants.NewsCell.minSpacing / 2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch layoutStyle {
        case .potrait:
            return 0
        case .landscape:
            return Constants.NewsCell.minSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch layoutStyle {
        case .potrait:
            return Constants.NewsCell.minSpacing
        case .landscape:
            return Constants.NewsCell.minSpacing
        }
    }
    
}

// MARK: - NewsViewCell Delegate
extension NewsListViewController: NewsViewCellDelegate {
    func filterNewsBy(filter filterType: String) {
        if let news = self.news {
            state = .filtered
            filteredNews = news.filter {$0.newsTypeFilter == filterType}
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                     target: self,
                                                                     action: #selector(cancelFilter))
            self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.primaryTextColor
            self.newsCollectionView?.reloadData()
        }
    }
}

// MARK: - Constant for cell spacing
private extension Constants {
    struct NewsCell {
        static let minSpacing: CGFloat = 10
        static let cellHeightInLandscape: CGFloat = 470
    }
}
