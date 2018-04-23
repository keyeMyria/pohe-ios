//
//  RootRouter.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import UIKit

protocol RootWireframe: class {
    func showRootScreen()
}

public class RootRouter: RootWireframe {
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func showRootScreen() {
            let initVC = ArticleRouter.assembleModule()
            window.rootViewController = initVC
            window.makeKeyAndVisible()
        
    }
}
