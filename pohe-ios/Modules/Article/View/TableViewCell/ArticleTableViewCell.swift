//
//  ArticleTableViewCell.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/24.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//


import Foundation
import UIKit
import Reusable
import Nuke

class ArticleTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var samune: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupArticle(_ article: Article) {
        label.text = article.page.title
        var url = URL(string: article.page.thumbnail ?? "https://www.pakutaso.com/shared/img/thumb/PAK85_graynohikari20141108124928_TP_V.jpg")!
        Manager.shared.loadImage(with: url, into: samune, handler: { [weak self] (image: Result<UIImage>, _) in
            guard let weakSelf = self, let image = image.value else { return }
            weakSelf.samune.image = image.cropping2square()
        })

    }
    
}
