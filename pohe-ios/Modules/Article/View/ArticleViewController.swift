//
//  ArticleArticleViewController.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

protocol ArticleView {
//    func showNoContentView()
    func showArticles(articles: [Article])
    func updateArticles(articles: [Article])
}

class ArticleViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableView: UITableView!
    var output: ArticleViewOutput!
    var presenter: ArticlePresentation!
    var articles: [Article] = []
    var itemInfo = IndicatorInfo(title: "View")
    private let bag = DisposeBag()
    private var refreshControl = UIRefreshControl()

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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
    
    private func setupRx() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in self?.presenter.pullToRefresh() })
            .disposed(by: bag)

         tableView.rx.reachedBottom
            .asObservable()
            .subscribe(onNext: { [weak self] _ in self?.presenter.reachedBottom() })
            .disposed(by: bag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func set(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
    }

}

extension ArticleViewController: ArticleView {

    func showArticles(articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
        refreshControl.endRefreshing()
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
        WebViewUtil.showWKWebView(urlString: article.page.url, viewTitle: article.page.title, from: nc, disAppear: {})
//        self.presenter.didSelect(with: tweet.user)
    }
}
