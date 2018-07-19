//
//  HistoryViewController.swift
//  pohe-ios
//


import Foundation
import UIKit
import WebKit
import RxSwift
import Realm

final class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var cancel: UIBarButtonItem!
    // Tableで使用する配列を設定する
    
    private let disposeBag = DisposeBag()
    
    private var myTableView: UITableView!

    private var list = RealmManager.getEntityList(type: HistoryObject.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成(Status barの高さをずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        
        // Cell名の登録をおこなう.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceを自身に設定する.
        myTableView.dataSource = self
        
        // Delegateを自身に設定する.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let history = list[indexPath.row]
        guard let nc = self.navigationController else {
            return
        }
        WebViewUtil.showWKWebView(page: history.fromObject(page: history.page!), from: nc, disAppear: {})
//        print("Num: \(indexPath.row)")
//        print("Value: \(myItems[indexPath.row])")
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    /*
     Cellに値を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        
        // Cellに値を設定する.
//        cell.textLabel!.text = "\(myItems[indexPath.row])"
        
        let item = list[indexPath.row];
        
        cell.textLabel?.text = item.page?.title;
        cell.detailTextLabel?.text = item.page?.url;
        
        return cell
    }
    
    private func initButton() {
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }

}

