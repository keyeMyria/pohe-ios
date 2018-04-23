//
//  ArticleArticleInteractor.swift
//  pohe-ios
//
//  Created by seki on 23/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

protocol ArticleUsecase: class {
    var output: ArticleInteractorOutput! { get }
    func fetch(with category: String)
}

class ArticleInteractor: ArticleUsecase {
    weak var output: ArticleInteractorOutput!
    private let bag = DisposeBag()
    private let session = Session.shared
    
    func fetch(with category: String) {
        let request = RestAPI.GetArticlesRequest(category: category)
        session.rx.response(request: request).share()
            .subscribe(
                { [weak self] (articles: [Article]) in
                    self?.output.articlesFetched(articles)
                }
            )
            .disposed(by: bag)
    }
    
    func addArticles(category: String, page: Int) {
        let request = RestAPI.GetArticlesRequest(category: category, page: page)
        session.rx.response(request: request).share()
            .subscribe(
                onNext: { [weak self] (articles: [Article]) in
                    self?.output.articlesAdded(articles)
                }
            )
            .disposed(by: bag)
    }
}

