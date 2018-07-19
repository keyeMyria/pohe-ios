//
//  LocalWebViewController.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/04.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class LocalWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    private var url: String = ""
    private var page: PageObject? = nil
    private let disposeBag = DisposeBag()
    private var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        setupWebView()
        self.setupButton()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect(origin: .zero, size: container.frame.size)
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        container.addSubview(webView)
        guard let url = NSURL(string: self.url) else {
            return
        }
        
        let request = NSURLRequest(url: url as URL) as URLRequest?
        let mutableRequest = request as! NSMutableURLRequest
        let cache = URLCache.shared
        let response = cache.cachedResponse(for: mutableRequest as URLRequest)
        webView.load(response!.data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url as URL)
//        URLProtocol.setProperty(true, forKey: "", in: mutableRequest)
//        webView.load(mutableRequest as URLRequest)
        
        
//        let urlToCache = NSURL(string: self.url)
//        let request = NSURLRequest(url: urlToCache! as URL )
//        let cache = URLCache.shared
//        let response = cache.cachedResponse(for: request as URLRequest)
//        webView.load(response!.data, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: urlToCache! as URL)
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
