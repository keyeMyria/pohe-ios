//
//  WebViewExtension.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/25.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import SafariServices

final class WebViewUtil {
    
    class func showWebView(urlString: String, viewTitle: String? = "", from: UINavigationController, disAppear: @escaping () -> Void) {
        let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let encodeUrl = encodeString, let url = URL(string: encodeUrl), ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationCapturesStatusBarAppearance = true
        from.present(safariViewController, animated: true, completion: nil)
        
    }
    
}
