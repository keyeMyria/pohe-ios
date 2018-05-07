//
//  MainMainViewController.swift
//  pohe-ios
//
//  Created by seki on 26/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: BaseButtonBarPagerTabStripViewController<TabCollectionViewCell> {

    private let articles1 = ArticleRouter.assembleView()
    private let articles2 = ArticleRouter.assembleView()
    private let articles3 = ArticleRouter.assembleView()
    private let articles4 = ArticleRouter.assembleView()
    private let articles5 = ArticleRouter.assembleView()
    
    var output: MainViewOutput!
    var presenter: MainPresentation!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonBarItemSpec = .nibFile(nibName: String(describing: type(of: TabCollectionViewCell())), bundle: Bundle(for: TabCollectionViewCell.self), width: { cell in
            return 70
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupInitialState() {
    }
    
    override func configure(cell: TabCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        cell.text = indicatorInfo.title
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let childViewControllers = [articles1, articles2,articles3, articles4, articles5]
        return childViewControllers
    }
}
