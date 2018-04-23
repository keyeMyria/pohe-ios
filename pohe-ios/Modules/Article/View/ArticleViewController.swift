//
//  ArticleArticleViewController.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, ArticleViewInput {

    var output: ArticleViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: ArticleViewInput
    func setupInitialState() {
    }
}
