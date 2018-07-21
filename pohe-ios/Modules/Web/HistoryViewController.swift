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

    private var list: [HistoryObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        initList()
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
        let article = Article(_id: "", page: history.fromObject(page: history.page!), category: Category(_id:"",name:(history.page?.category)!), score: (history.page?.score)!)
        
        WebViewUtil.showWKWebView(article: article, from: nc, disAppear: {})
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
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel?.text = (item.page?.url)! +
            "\n" +
            Date.human(date: (item.page?.createAt!)!);
        
        return cell
    }
    
    private func initButton() {
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func initList() {
        RealmManager.getEntityList(type: HistoryObject.self).sorted(byKeyPath: "createAt", ascending: false).forEach {
            self.list.append($0)
        }
//        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //            let a = indexPath.row
            RealmManager.deleteEntity(object: self.list[indexPath.row])
            self.list.remove(at: indexPath.row)
            //            self.memos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

