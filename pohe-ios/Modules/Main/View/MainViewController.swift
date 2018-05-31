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

    private let articles_array = [
        ArticleRouter.assembleView("javascript"),
        ArticleRouter.assembleView("php"),
        ArticleRouter.assembleView("java"),
        ArticleRouter.assembleView("ruby"),
        ArticleRouter.assembleView("python"),
        ArticleRouter.assembleView("objective-c"),
//    private let articles4 = ArticleRouter.assembleView("ios")
        ArticleRouter.assembleView("android"),
        ArticleRouter.assembleView("design"),
        ArticleRouter.assembleView("machine-learning"),
        ArticleRouter.assembleView("programming"),
        ArticleRouter.assembleView("windows"),
        ArticleRouter.assembleView("gadget"),
        ArticleRouter.assembleView("social"),
        ArticleRouter.assembleView("security"),
        ArticleRouter.assembleView("infrastructure")
    ]
    
    var output: MainViewOutput!
    var presenter: MainPresentation!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonBarItemSpec = .nibFile(nibName: String(describing: type(of: TabCollectionViewCell())), bundle: Bundle(for: TabCollectionViewCell.self), width: { cell in
            return 100
        })
        changeBarView()
    }

    override func viewDidLoad() {
        // バーの色
//        settings.style.buttonBarBackgroundColor = .blue
        // タブバーを画面幅におさめるかどうか
        settings.style.buttonBarItemsShouldFillAvailiableWidth = false
//        settings.style.buttonBarMinimumLineSpacing = 15
//        settings.style.buttonBarMinimumInteritemSpacing = 15
        // セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor(named: .colorAccent)
//        settings.style.buttonBarLeftContentInset = 20
//        settings.style.buttonBarRightContentInset = 20
        settings.style.selectedBarHeight = 3
        self.navigationController?.navigationBar.barTintColor = UIColor(named: .colorPrimary)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor(named: .white)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        super.viewDidLoad()
        self.navigationItem.title = "Pohe"
    }
    
    // タブの文字色を変更
    private func changeBarView() {
        changeCurrentIndexProgressive = { (oldCell: TabCollectionViewCell?, newCell: TabCollectionViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.textColor = .gray
            newCell?.textColor = .black
        }
    }

    func setupInitialState() {
    }
    
    override func configure(cell: TabCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        cell.text = indicatorInfo.title
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let childViewControllers = articles_array
        return childViewControllers
    }
}
