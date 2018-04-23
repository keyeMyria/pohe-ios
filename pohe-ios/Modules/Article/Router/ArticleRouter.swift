//
//  ArticleArticleRouter.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit

class ArticleRouter: ArticleRouterInput {
    weak var viewController: UIViewController?


    static func assembleModule() -> UIViewController {
        
        let view = StoryboardScene.ArticleViewController.initialScene.instantiate()
        let interactor = ArticleInteractor()
        let router = ArticleRouter(viewController: view)
        
        // memo: Presenterは依存関係が多いので、イニシャライザで参照渡す。
        let presenter = ArticlePresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        
        let nav = UINavigationController(rootViewController: view)
        return nav
    }

}
