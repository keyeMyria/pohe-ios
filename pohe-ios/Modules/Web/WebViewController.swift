//
//  WebViewController.swift
//  pohe-ios
//
//

import UIKit
import WebKit
import RxSwift

final class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var bookmark: UIBarButtonItem!
    
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var forward: UIBarButtonItem!
    private var webView: WKWebView!
    private var progressView = UIProgressView()
    private var url: String = ""
    private var page: Page? = nil
    private var score: Int = 0
    private var category: String = ""
    private var mutableRequest: NSMutableURLRequest!
    
    let isWebViewClose = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupButton()
        setBackForwardStatus()
        setupProgress()
    }
    
//    deinit {
//        self.webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
//        self.webView.removeObserver(self, forKeyPath: "loading", context: nil)
//        self.webView.removeObserver(self, forKeyPath: "URL", context: nil)
//    }
    
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isWebViewClose.onNext(())
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
//        webView.frame = CGRect(origin: .zero, size: container.frame.size)
        addObservers()
        container.addSubview(webView)
        guard let url = NSURL(string: self.url) else {
            return
        }
        
        let request = NSURLRequest(url: url as URL) as URLRequest?
        mutableRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "", in: mutableRequest)
        webView.load(mutableRequest as URLRequest)
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
        back.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.webView.goBack()
        }).disposed(by: disposeBag)
        forward.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.webView.goForward()
        }).disposed(by: disposeBag)
    }
    
    private func setupProgress() {
        self.progressView = UIProgressView(frame: CGRect(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)! - 3.0, width: self.view.frame.size.width, height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)

    }
    
    private func showActivity() {
        let shareText = title ?? "シェアされました"
        let shareWebsite = NSURL(string: url)!
        let activityItems: [Any] = [shareText, shareWebsite]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activity, animated: true)
    }
    
    private func saveCache() {
        let p = PageObject(page:page!)
        p.score = score
        p.category = category
        RealmManager.addEntity(object: p)
        guard let url = NSURL(string: page!.url) else {
            return
        }
        let cache = URLCache.shared
        let data = NSData.init(contentsOf: url as URL)
        let urlResponse = URLResponse(url: url as URL,
                                      mimeType: "text/html",
                                      expectedContentLength: 0,
                                      textEncodingName: "UTF-8")
        let response = CachedURLResponse.init(response: urlResponse, data: data! as Data, userInfo: nil, storagePolicy: .allowed)
        let myrequest = NSURLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0) as URLRequest
//        let myrequest = mutableRequest as URLRequest
        cache.storeCachedResponse(response, for: myrequest)
        showToast(message: "Bookmarked!")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        view.showBlurLoader()
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
    
    func setBackForwardStatus() {
        back.isEnabled = webView.canGoBack
        forward.isEnabled = webView.canGoForward
    }

}

extension WebViewController {

    func initWeb(article: Article) -> UINavigationController {
        let vc = StoryboardScene.Web.webViewController.instantiate()
        vc.page = article.page
        vc.url = article.page.url
        vc.title = article.page.title
        vc.score = article.score
        vc.category = article.category.name
        let nc = UINavigationController(rootViewController: vc)
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.sizeToFit()
        vc.navigationItem.titleView = label

        return nc
    }

}

