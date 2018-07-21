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
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var forward: UIBarButtonItem!
    private var progressView = UIProgressView()
    private var url: String = ""
    private var page: PageObject? = nil
    private let disposeBag = DisposeBag()
    private var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        setupWebView()
        setupButton()
        setBackForwardStatus()
        setupProgress()
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
        addObservers()
        container.addSubview(webView)
        guard let url = NSURL(string: self.url) else {
            return
        }
        
        let request = NSURLRequest(url: url as URL) as URLRequest?
        let mutableRequest = request as! NSMutableURLRequest
        let cache = URLCache.shared
        let response = cache.cachedResponse(for: mutableRequest as URLRequest)
        if (response == nil) {
            webView.load(mutableRequest as URLRequest)
        } else {
            webView.load(response!.data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url as URL)
        }
        
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
        back.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.webView.goBack()
        }).disposed(by: disposeBag)
        forward.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.webView.goForward()
        }).disposed(by: disposeBag)
    }
    
    private func showActivity() {
        let shareText = title ?? "シェアされました"
        let shareWebsite = NSURL(string: url)!
        let activityItems: [Any] = [shareText, shareWebsite]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activity, animated: true)
    }
    
    func addObservers(){
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.new, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: NSKeyValueObservingOptions.new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: NSKeyValueObservingOptions.new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoForward", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            break
            
        case "loading":
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
            if (self.webView.isLoading) {
                self.progressView.setProgress(0.1, animated: true)
            }else{
                // 読み込みが終わったら0.0をセット
                self.progressView.setProgress(0.0, animated: false)
            }
            break
        case "URL":
            setBackForwardStatus()
            break
        case "canGoForward":
            setBackForwardStatus()
            break
        case "canGoBack":
            setBackForwardStatus()
            break
        default:
            break
        }
    }
    
    func setBackForwardStatus() {
        back.isEnabled = webView.canGoBack
        forward.isEnabled = webView.canGoForward
    }
    
    private func setupProgress() {
        self.progressView = UIProgressView(frame: CGRect(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)! - 3.0, width: self.view.frame.size.width, height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)
    }
}
