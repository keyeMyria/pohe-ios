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
    private let category: String
    var articles: [Article]
    var isLoading: Bool
    var page: Int

    var interactor: ArticleUsecase
    var router: ArticleRouter
    
    required init(view: ArticleViewController?, router: ArticleRouter, interactor: ArticleUsecase) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.category = "javascript"
        self.articles = []
        self.isLoading = false
        self.page = 1
    }
    
    func viewDidLoad() {
        interactor.fetch(with: category)
    }
    
    func pullToRefresh() {
        interactor.fetch(with: category)
    }
    
    func reachedBottom() {
        page = page + 1
        if isLoading { return }
        isLoading = true
        interactor.addArticles(category: category, page: page)
    }

}
extension ArticlePresenter: ArticleInteractorOutput {}

