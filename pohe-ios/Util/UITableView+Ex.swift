//
//  UITableView+Ex.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/08/14.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import UIKit
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
