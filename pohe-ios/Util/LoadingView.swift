//
//  LoadingView.swift
//  pohe-ios
//

import UIKit
class LoadingView {
    var activityIndicator: UIActivityIndicatorView!
    func initLoadingView() -> UIActivityIndicatorView {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        // クルクルをストップした時に非表示する
        activityIndicator.hidesWhenStopped = true
        
        // 色を設定
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        return activityIndicator
    }
    
    func show() {
        activityIndicator.startAnimating()
    }
    
    func dismiss() {
        activityIndicator.stopAnimating()
    }
}
