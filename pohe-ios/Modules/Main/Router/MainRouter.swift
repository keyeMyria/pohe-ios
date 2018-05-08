//
//  MainMainRouter.swift
//  pohe-ios
//
//  Created by seki on 26/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

//
//  ArticleArticleRouter.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit

class MainRouter: MainRouterInput {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    static func assembleModule() -> UIViewController {
        let view = StoryboardScene.MainViewController.initialScene.instantiate()
        let interactor = MainInteractor()
        let router = MainRouter(viewController: view)
        
        // memo: Presenterは依存関係が多いので、イニシャライザで参照渡す。
        let presenter = MainPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
//        return view
        let nav = UINavigationController(rootViewController: view)
        return nav
    }
    
}

