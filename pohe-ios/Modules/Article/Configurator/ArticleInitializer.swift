//
//  ArticleArticleInitializer.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit

class ArticleModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var articleViewController: ArticleViewController!

    override func awakeFromNib() {

        let configurator = ArticleModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: articleViewController)
    }

}
