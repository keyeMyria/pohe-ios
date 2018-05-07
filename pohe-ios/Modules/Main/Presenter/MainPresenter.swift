//
//  MainMainPresenter.swift
//  pohe-ios
//
//  Created by seki on 26/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

protocol MainPresentation: class {
    var view: MainViewController? { get }
    init(
        view: MainViewController?,
        router: MainRouter,
        interactor: MainUsecase
    )
    func viewDidLoad()
}


class MainPresenter: MainPresentation {

    weak var view: MainViewController?
    var interactor: MainUsecase
    var router: MainRouter
    
    required init(view: MainViewController?, router: MainRouter, interactor: MainUsecase) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewIsReady() {

    }
    
    func viewDidLoad() {
        
    }
}

extension MainPresenter: MainInteractorOutput {}
