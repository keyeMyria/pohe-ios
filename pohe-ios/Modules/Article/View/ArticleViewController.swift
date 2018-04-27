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
    private let bag = DisposeBag()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRx()
//        output.viewIsReady()
        presenter.viewDidLoad()
    }
    
    private func setupView() {
        self.navigationItem.title = "記事"
        
        tableView.register(cellType: ArticleTableViewCell.self)
//        tableView.estimatedRowHeight = 150
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 120.0
//        tableView.rowHeight = 150.0
//        tableView.separatorInset = UIEdgeInsets.zero
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.refreshControl = refreshControl
//        noDataLabel.isHidden = true
    }
    
    private func setupRx() {
         tableView.rx.reachedBottom
            .asObservable()
            .subscribe(onNext: { [weak self] _ in self?.presenter.reachedBottom() })
            .disposed(by: bag)
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
        cell.samune.image = nil
        cell.setupArticle(articles[indexPath.row])
        return cell
    }

}

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let nc = self.navigationController else {
            return
        }
        WebViewUtil.showWebView(urlString: article.page.url, from: nc, disAppear: {})
//        self.presenter.didSelect(with: tweet.user)
    }
}
