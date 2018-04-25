//
//  ArticleArticleInteractorOutput.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import Foundation

protocol ArticleInteractorOutput: class {
    var view: ArticleViewController? { get }
    var articles: [Article] { get set }
    var isLoading: Bool { get set }
    func articlesFetched(_ tweets: [Article])
    func articlesAdded(_ tweets: [Article])
}

extension ArticleInteractorOutput {
    func articlesFetched(_ articles: [Article]) {
        isLoading = false
        if articles.isEmpty {
//            view?.showNoContentView()
        } else {
            self.articles = articles
            view?.showArticles(articles: self.articles)
        }
    }
    
    func articlesAdded(_ articles: [Article]) {
        isLoading = false
        if articles.isEmpty {
            return
        }
        self.articles += articles
        view?.updateArticles(articles: self.articles)
    }
}
