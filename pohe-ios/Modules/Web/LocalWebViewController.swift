//
//  LocalWebViewController.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/04.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import Mattress
import RxSwift

class LocalWebViewController: UIViewController {
    
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    private var url: String = ""
    private var page: PageObject? = nil
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        let urlToCache = NSURL(string: self.url)
        let request = NSURLRequest(url: urlToCache! as URL )
        webView.loadRequest(request as URLRequest)
        self.setupButton()
    }
    
    func initWeb(page: PageObject) -> UINavigationController {
        let vc = StoryboardScene.LocalWeb.localWebViewController.instantiate()
        vc.page = page
        vc.url = page.url
        vc.title = page.title
        
        let nc = UINavigationController(rootViewController: vc)
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.sizeToFit()
        vc.navigationItem.titleView = label
        
        return nc
    }
    
    private func setupButton() {
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        share.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.showActivity()
        }).disposed(by: disposeBag)
    }
    
    private func showActivity() {
        let shareText = title ?? "シェアされました"
        let shareWebsite = NSURL(string: url)!
        let activityItems: [Any] = [shareText, shareWebsite]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activity, animated: true)
    }
}
