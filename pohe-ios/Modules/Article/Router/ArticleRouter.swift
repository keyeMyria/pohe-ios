//
//  ArticleArticleRouter.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ArticleRouter: ArticleRouterInput  {
    
    weak var viewController: UIViewController?

    required init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    static func assembleModule() -> UIViewController {
        let view = StoryboardScene.ArticleViewController.initialScene.instantiate()
//        view.set(itemInfo: view.indicatorInfo(title: "View"))
        let interactor = ArticleInteractor()
        let router = ArticleRouter(viewController: view)
        // memo: Presenterは依存関係が多いので、イニシャライザで参照渡す。
        let presenter = ArticlePresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        
        let nav = UINavigationController(rootViewController: view)
        return nav
    }
    
    static func assembleView() -> UIViewController {
        let view = StoryboardScene.ArticleViewController.initialScene.instantiate()
//        view.set(itemInfo: IndicatorInfo(title: "View"))
        let interactor = ArticleInteractor()
        let router = ArticleRouter(viewController: view)
        // memo: Presenterは依存関係が多いので、イニシャライザで参照渡す。
        let presenter = ArticlePresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        return view
    }

}
