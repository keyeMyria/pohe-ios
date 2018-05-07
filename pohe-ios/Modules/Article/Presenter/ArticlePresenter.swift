//
//  ArticleArticlePresenter.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//
import Foundation
import RxSwift

protocol ArticlePresentation: class {
    var view: ArticleViewController? { get }
    init(
        view: ArticleViewController?,
        router: ArticleRouter,
        interactor: ArticleUsecase
    )
    
    func viewDidLoad()
    func pullToRefresh()
    func reachedBottom()
}

class ArticlePresenter: ArticlePresentation {
    weak var view: ArticleViewController?
    var category: String
    var articles: [Article]
    var isLoading: Bool
    var offset: Int

    var interactor: ArticleUsecase
    var router: ArticleRouter
    
    required init(view: ArticleViewController?, router: ArticleRouter, interactor: ArticleUsecase) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.category = "javascript"
        self.articles = []
        self.isLoading = false
        self.offset = 0
    }
    
    func viewDidLoad() {
        interactor.fetch(with: category)
    }
    
    func pullToRefresh() {
        interactor.fetch(with: category)
    }
    
    func reachedBottom() {
        offset = offset + articles.count
        if isLoading { return }
        isLoading = true
        interactor.addArticles(category: category, offset: offset)
    }

}
extension ArticlePresenter: ArticleInteractorOutput {}

