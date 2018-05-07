//
//  MainMainInteractor.swift
//  pohe-ios
//
//  Created by seki on 26/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

protocol MainUsecase: class {
    var output: MainInteractorOutput! { get }
}

class MainInteractor: MainUsecase {

    weak var output: MainInteractorOutput!

}
