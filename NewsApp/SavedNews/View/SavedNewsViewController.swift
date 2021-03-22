//
//  SavedNewsViewController.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-17.
//

import UIKit

class SavedNewsViewController: UIViewController {
    // MARK: - Property
    @IBOutlet private weak var newsTableView: UITableView?
    @IBOutlet private weak var emptyTitleLabel: UILabel?
    
    var viewModel: SavedNewsViewModel?
    var news: News?
    
    override func viewDidLoad() {
        viewModel?.delegate = self
        self.setUpTableView()
        self.emptyTitleLabel?.text = Constants.SavedNews.emptyCellTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchDataFromDisk()
    }
}

// MARK: - Private methods
private extension SavedNewsViewController {
    
    func setUpTableView() {
        newsTableView?.delegate = self
        newsTableView?.dataSource = self
        newsTableView?.register(UINib(nibName: Constants.ViewCells.savedNewsCell, bundle: nil),
                                forCellReuseIdentifier: Constants.ViewCells.savedNewsCell)
        newsTableView?.reloadData()
    }
    
    func setUpNavigationBar(title: String) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(didTapClearAll))
        
        self.navigationController?.navigationBar.barTintColor = Constants.Color.primaryRedColor
        self.navigationController?.navigationBar.tintColor = Constants.Color.primaryTextColor
        let textAttribute = [NSAttributedString.Key.foregroundColor: Constants.Color.primaryTextColor]
            self.navigationController?.navigationBar.titleTextAttributes = textAttribute
    }
    
    @objc func didTapClearAll() {
        viewModel?.clearAllDataFromDisk()
        self.news?.removeAll()
        reloadTableView()
    }
    
    func reloadTableView() {
        guard let news = self.news else { return }
        emptyTitleLabel?.isHidden = !news.isEmpty
        self.view.backgroundColor = news.isEmpty ? .white: .black
        self.newsTableView?.reloadData()
    }
}

// MARK: - TableView Datasource
extension SavedNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        Constants.ViewCells.savedNewsCell) as? SavedNewsCell,
           let news = news, !news.isEmpty {
            cell.configureCell(indexPath, news: news[indexPath.row] )
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension SavedNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { _, _, completionHandler in
            self.news?.remove(at: indexPath.row)
            self.reloadTableView()
            self.viewModel?.removeData(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        deleteAction.title = "Delete"
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - ViewModel delegate
extension SavedNewsViewController: SavedNewsViewModelDelegate {
    
    func showViewModelOutput(_ output: SavedNewsViewModelOutput) {
        switch output {
        case .showTitle(let title):
            self.setUpNavigationBar(title: title )
        case .showSavedNews(let news):
            self.news = news
            reloadTableView()
        }
    }
    
}
