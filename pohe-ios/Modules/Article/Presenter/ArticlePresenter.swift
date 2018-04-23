//
//  ArticleArticlePresenter.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

class ArticlePresenter: ArticleModuleInput, ArticleViewOutput, ArticleInteractorOutput {

    weak var view: ArticleViewInput!
    var interactor: ArticleInteractorInput!
    var router: ArticleRouterInput!

    func viewIsReady() {

    }
}
