//
//  ArticleArticleConfigurator.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit

class ArticleModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? ArticleViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: ArticleViewController) {

        let router = ArticleRouter()

        let presenter = ArticlePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ArticleInteractor()
        interactor.output = presenter

        presenter.interactor = interactor as! ArticleInteractorInput
        viewController.output = presenter
    }

}
