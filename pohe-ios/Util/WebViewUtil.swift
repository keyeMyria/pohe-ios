//
//  WebViewExtension.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/25.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import SafariServices
import RxSwift
import RxCocoa

final class WebViewUtil {
    static let disposeBag = DisposeBag()
    
    class func showWebView(urlString: String, viewTitle: String? = "", from: UINavigationController, disAppear: @escaping () -> Void) {
        let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let encodeUrl = encodeString, let url = URL(string: encodeUrl), ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationCapturesStatusBarAppearance = true
        from.present(safariViewController, animated: true, completion: nil)
        
    }
    
    class func showWKWebView(urlString: String, viewTitle: String? = "", from: UINavigationController, disAppear: @escaping () -> Void) {
        let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let encodeUrl = encodeString, let url = URL(string: encodeUrl), ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            return
        }
        let nc = WebViewController().initWeb(url: encodeUrl, viewTitle: viewTitle)
        let webview = nc.viewControllers.first as! WebViewController
        webview.isWebViewClose.asDriver(onErrorDriveWith: Driver.empty())
            .drive(
                onNext: {
                    disAppear()
            }).disposed(by: disposeBag)
        from.present(nc, animated: true, completion: nil)
    }
    
}
