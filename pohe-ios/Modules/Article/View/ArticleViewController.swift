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
    private lazy var longPressRecognizer: UILongPressGestureRecognizer =
        UILongPressGestureRecognizer(target: self, action: .cellLongPressed)

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRx()
//        output.viewIsReady()
        presenter.viewDidLoad()
        setupRecognizer()
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
    
    private func saveCache(article: Article) {
        let p = PageObject(page:article.page)
        p.score = article.score
        p.category = article.category.name
        RealmManager.addEntity(object: p)
        guard let url = NSURL(string: article.page.url) else {
            return
        }
        let cache = URLCache.shared
        let data = NSData.init(contentsOf: url as URL)
        let urlResponse = URLResponse(url: url as URL,
                                      mimeType: "text/html",
                                      expectedContentLength: 0,
                                      textEncodingName: "UTF-8")
        let response = CachedURLResponse.init(response: urlResponse, data: data! as Data, userInfo: nil, storagePolicy: .allowed)
        let request = NSURLRequest(url: url as URL) as URLRequest?
        let mutableRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "", in: mutableRequest)
        let myrequest = mutableRequest as URLRequest
        cache.storeCachedResponse(response, for: myrequest)
        showToast(message: "Bookmarked!")
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
//        let longPress =
//            UILongPressGestureRecognizer(target: self, action: Selector("cellLongPressed:"))
//        cell.addGestureRecognizer(longPress);
        return cell
    }
    
//    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
//        let point = recognizer.location(in: tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//        let article = articles[(indexPath?.row)!]
//        if recognizer.state == UIGestureRecognizerState.began {
//            saveCache(article: article)
//        }
//    }

}

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let nc = self.navigationController else {
            return
        }
        let p = HistoryObject(p:article.page)
        p.page?.score = article.score
        p.page?.category = article.category.name
        RealmManager.addEntity(object: p)
        WebViewUtil.showWKWebView(article: article, from: nc, disAppear: {})
    }
}

extension ArticleViewController: UIGestureRecognizerDelegate {

    private func setupRecognizer() {
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
    }

    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let isAllow = UserDefaults.standard.bool(forKey: "longPress")
        if (!isAllow) {
            return
        }
        
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let article = articles[(indexPath?.row)!]
        
        if recognizer.state == UIGestureRecognizerState.began {
            saveCache(article: article)
        }
    }
}

private extension Selector {
    
    static let cellLongPressed = #selector(ArticleViewController.cellLongPressed(recognizer:))
}
