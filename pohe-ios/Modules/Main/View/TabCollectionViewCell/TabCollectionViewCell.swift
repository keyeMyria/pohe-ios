//
//  TabCollectionViewCell.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/26.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit

final class TabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    var textColor: UIColor? {
        didSet {
            if let color = textColor {
                titleLabel.textColor = color
            }
        }
    }
    
    var text: String? {
        didSet {
            if let text = text {
                titleLabel.text = text.uppercased()
            }
        }
    }
    
}
