//
//  UIViewController+ScrollingNavbar.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/02.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UIViewController {
    
//    func setupModalNavigationBar() {
//        navigationController?.navigationBar.barTintColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.0)
//        let closeButton = UIBarButtonItem(image: Asset.Icons.icClose.image, style: .plain, target: self, action: #selector(tapCloseButton))
//        navigationItem.setRightBarButton(closeButton, animated: false)
//    }
//    
//    @objc func tapCloseButton() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func getNavigationController() -> UINavigationController? {
//        guard let nc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let container = nc.viewControllers.first as? ContainerViewController, let navigationController = container.mainViewController as? UINavigationController else {
//            return nil
//        }
//        return navigationController
//    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {_ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
