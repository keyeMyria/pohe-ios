//
//  WebViewController.swift
//  pohe-ios
//
//

import UIKit
import WebKit
import RxSwift

final class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var bookmark: UIBarButtonItem!
    
    @IBOutlet weak var share: UIBarButtonItem!
    private var webView: WKWebView!
    private var url: String = ""
    let isWebViewClose = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
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
        }).addDisposableTo(disposeBag)
    }
    
    private func showActivity() {
        let shareText = title ?? "シェアされました"
        let shareWebsite = NSURL(string: url)!
        let activityItems: [Any] = [shareText, shareWebsite]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activity, animated: true)
    }
}

extension WebViewController {

    func initWeb(url: String, viewTitle: String? = "", isVideoDetail: Bool = false) -> UINavigationController {
        let vc = StoryboardScene.Web.webViewController.instantiate()
        vc.url = url
        vc.title = viewTitle
        
        let nc = UINavigationController(rootViewController: vc)
        
        if let title = viewTitle, !title.isEmpty {
            let label = UILabel()
            label.text = title
            label.textColor = .white
            label.sizeToFit()
            vc.navigationItem.titleView = label
        }

        return nc
    }
}

