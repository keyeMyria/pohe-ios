//
//  MainMainViewController.swift
//  pohe-ios
//
//  Created by seki on 26/04/2018.
//  Copyright © 2018 pohe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class MainViewController: BaseButtonBarPagerTabStripViewController<TabCollectionViewCell>, UITabBarDelegate {

    private let categories = [
        "javascript",
        "php",
        "java",
        "ruby",
        "python",
        "objective-c",
        "programming",
        "design",
        "android",
        "ios",
        "windows",
        "machine-learning",
        "gadget",
        "social",
        "security",
        "infrastructure",
        "iot"
    ]
    
    var output: MainViewOutput!
    var presenter: MainPresentation!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tabbar: UITabBar!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonBarItemSpec = .nibFile(nibName: String(describing: type(of: TabCollectionViewCell())), bundle: Bundle(for: TabCollectionViewCell.self), width: { cell in
            guard let title = cell.title else {
                return 70
            }
            if (title == "android") {
                return CGFloat("android-java".count * 10 + 20)
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
        tabbar.delegate = self
//        removeTabbarItemsText()
        
        super.viewDidLoad()
        self.navigationItem.title = "Pohe"
        self.setButton()
        
    }
    
    private func setButton() {
//        let bookmark = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)
//        let organize = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
//        self.navigationItem.rightBarButtonItems = [organize]
//        bookmark.tintColor = .white
//        organize.tintColor = .white
//        bookmark.rx.tap.subscribe(onNext: {[weak self] in
//            self?.goPages()
//        }).disposed(by: disposeBag)
//        organize.rx.tap.subscribe(onNext: {[weak self] in
//            self?.goMenu()
//        }).disposed(by: disposeBag)
        
    }
    
    func removeTabbarItemsText() {
        
        var offset: CGFloat = 9.0
        
        if #available(iOS 11.0, *), traitCollection.horizontalSizeClass == .regular {
//            offset = 0.0
        }
        
        if let items = tabbar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.clear], for: .selected)
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.clear], for: .normal)
            }
        }
        
    }

    
    private func goPages() {
        let nc = PageViewController().initPages()
        self.navigationController?.present(nc, animated: true, completion: nil)
    }
    
    private func goMenu() {
        let nc = MenuViewController().initPages()
        self.navigationController?.present(nc, animated: true, completion: nil)
    }
    
    private func goSearch() {
        let nc = SearchViewController().initPages()
        self.navigationController?.present(nc, animated: true, completion: nil)
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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag{
        case 0:
//            print("home")
            self.moveToViewController(at: 0,animated: true)
        case 1:
            goSearch()
        case 2:
            goPages()
        case 3:
            goMenu()
        default : return
            
        }
    }
}
