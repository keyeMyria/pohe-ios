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

    private let categories = [
        "javascript",
        "php",
        "java",
        "ruby",
        "python",
        "objective-c",
        "ios",
        "android",
        "design",
        "machine-learning",
        "windows",
        "gadget",
        "social",
        "security",
        "infrastructure"
    ]
    
    var output: MainViewOutput!
    var presenter: MainPresentation!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonBarItemSpec = .nibFile(nibName: String(describing: type(of: TabCollectionViewCell())), bundle: Bundle(for: TabCollectionViewCell.self), width: { cell in
            guard let title = cell.title else {
                return 70
            }
            return CGFloat(title.count * 10 + 20)
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
        let childViewControllers = self.categories.map { ArticleRouter.assembleView($0) }
        return childViewControllers
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        if progressPercentage >= 1.0 && !indexWasChanged {
            let leftIndex = self.currentIndex - 1
            let rightIndex = self.currentIndex + 1
            if leftIndex >= 0 {
                let c = viewControllers[leftIndex]
                if !c.isViewLoaded {
                    c.loadViewIfNeeded()
                }
            }
            if rightIndex < self.viewControllers.count {
                let c = viewControllers[rightIndex]
                if !c.isViewLoaded {
                    c.loadViewIfNeeded()
                }
            }
        }
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
    }
}
