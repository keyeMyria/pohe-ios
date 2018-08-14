//
//  SearchTableViewCell.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/08/13.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import Reusable
import Nuke

class SearchTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var samune: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var site: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupArticle(_ article: Article) {
        title.text = article.page.title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.samune?.backgroundColor = UIColor(named: .darkAccent)
        samune.layer.shadowColor = UIColor.black.cgColor
        samune.layer.shadowOffset = .zero
        samune.layer.shadowOpacity = 0.1
        //        samune.layer.shadowRadius = 4
        time.text = Date.human(date: article.page.timestamp!)
        site.text = article.page.site_name
        point.text = String(repeating: "⭐️", count: article.score)
        guard let thumbnail = article.page.thumbnail else { return }
        if let url = URL(string: thumbnail) {
            Manager.shared.loadImage(with: url, into: samune, handler: { [weak self] (image: Result<UIImage>, _) in
                guard let weakSelf = self, let image = image.value else { return }
                weakSelf.samune.image = image.cropping2square()
            })
        }
    }
    
}

