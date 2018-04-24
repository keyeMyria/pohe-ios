//
//  ArticleArticleViewController.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ArticleView {
//    func showNoContentView()
    func showArticles(articles: [Article])
    func updateArticles(articles: [Article])
}

class ArticleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var output: ArticleViewOutput!
    var presenter: ArticlePresentation!
    var articles: [Article] = []

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        output.viewIsReady()
        presenter.viewDidLoad()
    }
    
    private func setupView() {
        self.navigationItem.title = "記事"
        
        tableView.register(cellType: ArticleTableViewCell.self)
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.refreshControl = refreshControl
//        noDataLabel.isHidden = true
    }

}

extension ArticleViewController: ArticleView {

    func showArticles(articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
//        refreshControl.endRefreshing()
    }
    
    func updateArticles(articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
    }
}

extension ArticleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//        cell.textLabel?.text = articles[indexPath.row]._id
        cell.setupArticle(articles[indexPath.row])
        return cell
    }
}

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
//        self.presenter.didSelect(with: tweet.user)
    }
}
