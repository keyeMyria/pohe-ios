//
//  WebViewController.swift
//  pohe-ios
//
//

import UIKit
import WebKit
import RxSwift
import Mattress

final class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var bookmark: UIBarButtonItem!
    
    @IBOutlet weak var share: UIBarButtonItem!
    private var webView: WKWebView!
    private var url: String = ""
    private var page: Page? = nil
    
    let isWebViewClose = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
//        view.showBlurLoader()
        setupWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect(origin: .zero, size: container.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isWebViewClose.onNext(())
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        container.addSubview(webView)
        guard let url = URL(string: self.url) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupButton() {
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        share.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.showActivity()
        }).disposed(by: disposeBag)
        bookmark.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.saveCache()
        }).disposed(by: disposeBag)
    }
    
    private func showActivity() {
        let shareText = title ?? "シェアされました"
        let shareWebsite = NSURL(string: url)!
        let activityItems: [Any] = [shareText, shareWebsite]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activity, animated: true)
    }
    
    private func saveCache() {
        RealmManager.addEntity(object: PageObject(page:page!))
        if let cache = NSURLCache.shared as? Mattress.URLCache, let urlToCache = URL(string: self.url) {
            cache.diskCacheURL(url: urlToCache, loadedHandler: { (webView) -> (Bool) in
                let state = webView.stringByEvaluatingJavaScript(from: "document.readyState")
                if state == "complete" {
                    // Loading is done once we've returned true
                    return true
                }
                return false
            }, completeHandler: { () -> Void in
                print("Finished caching")
            }, failureHandler: { (error) -> Void in
                print("Error caching: %@", error)
            })
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        view.showBlurLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.removeBluerLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.removeBluerLoader()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        view.removeBluerLoader()
        
//        ErrorAlert.showErrorDialog(error: error, disposeBag: disposeBag, callback: { _ in
//            
//        })
    }
}

extension WebViewController {

    func initWeb(page: Page) -> UINavigationController {
        let vc = StoryboardScene.Web.webViewController.instantiate()
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
}

