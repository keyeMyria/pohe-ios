//
//  PageTableViewCell.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/03.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Nuke

class PageTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var samune: UIImageView!
    
    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupPage(_ page: PageObject) {
        label.text = page.title
        self.samune?.backgroundColor = UIColor(named: .darkAccent)
//        guard let thumbnail = page.thumbnail else { return }
        if let url = URL(string: page.thumbnail) {
            Manager.shared.loadImage(with: url, into: samune, handler: { [weak self] (image: Result<UIImage>, _) in
                guard let weakSelf = self, let image = image.value else { return }
                weakSelf.samune.image = image.cropping2square()
            })
        }
    }
}
