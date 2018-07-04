//
//  TableViewController.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/03.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Mattress

class PageViewController: UIViewController {
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var pages: [PageObject] = []
//    var itemInfo = IndicatorInfo(title: "View")
    private let disposeBag = DisposeBag()
//    private var refreshControl = UIRefreshControl()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showPages()
        setupView()
        setupRx()
        //        output.viewIsReady()
//        presenter.viewDidLoad()
    }
    
    private func setupView() {
        self.navigationItem.title = "ブックマーク"
        
        tableView.register(cellType: PageTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupRx() {
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func showPages() {
        RealmManager.getEntityList(type: PageObject.self).forEach {
            self.pages.append($0)
        }
        tableView.reloadData()
    }
    
    func deletePage(index: Int) {
        RealmManager.deleteEntity(object: self.pages[index])
        self.pages.remove(at: index)
    }
    
    private func showBookMark(page: PageObject) {
        let nc = LocalWebViewController().initWeb(page: page)
        self.navigationController?.present(nc, animated: true, completion: nil)
    }
}

extension PageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.samune.image = nil
        cell.setupPage(pages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            let a = indexPath.row
            self.deletePage(index: indexPath.row)
//            self.memos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension PageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let page = pages[indexPath.row]
        guard let nc = self.navigationController else {
            return
        }
        self.showBookMark(page: page)
//        WebViewUtil.showWKWebView(page: article.page, from: nc, disAppear: {})
        //        self.presenter.didSelect(with: tweet.user)
    }
}

extension PageViewController {
    
    func initPages() -> UINavigationController {
        let vc = StoryboardScene.PageViewController.pageViewController.instantiate()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
}
