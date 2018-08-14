//
//  SearchViewController.swift
//  pohe-ios


import Foundation
import UIKit
import RxSwift
import RxCocoa
final class SearchViewController: UIViewController, UISearchBarDelegate, XMLParserDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var searchbar: UISearchBar!
//    private var refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    private lazy var longPressRecognizer: UILongPressGestureRecognizer =
        UILongPressGestureRecognizer(target: self, action: .cellLongPressed)


    // XMLParser のインスタンスを生成
    var parser = XMLParser()
    
    var pages = [Feed]()
    
    var currentElementName : String! // RSSパース中の現在の要素名
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "検索"
        let barImageView = searchbar.value(forKey: "_background") as! UIImageView
        barImageView.removeFromSuperview()
        searchbar.backgroundColor = UIColor.white
        let textField = searchbar.value(forKey: "_searchField") as! UITextField
        textField.backgroundColor = UIColor(named: .colorLight)
        tableview.backgroundColor = UIColor(named: .colorDark)
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        searchbar.delegate = self
        pages = []
        setupView()
        setupRx()
        setupRecognizer()
    }
    
    // 検索ボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
//        searchBar.showsCancelButton = true
        searchUrl(keyword: searchbar.text!.lowercased())
    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
//        self.tableView.reloadData()
    }
    
    // テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.showsCancelButton = true
        return true
    }
    
    private func setupView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(cellType: SearchTableViewCell.self)
//        tableview.refreshControl = refreshControl
    }
    
    private func setupRx() {
//        refreshControl.rx.controlEvent(.valueChanged)
//            .subscribe(onNext: { [weak self] _ in self?.presenter.pullToRefresh() })
//            .disposed(by: disposeBag)
//
//        tableview.rx.reachedBottom
//            .asObservable()
//            .subscribe(onNext: { [weak self] _ in self?.presenter.reachedBottom() })
//            .disposed(by: disposeBag)
    }
    
    private func searchUrl(keyword: String) {
        pages = []
        if (keyword.isEmpty) {return}
        let stringUrl = "http://b.hatena.ne.jp/search/tag?q=\(keyword)&mode=rss"
        let url = URL(string:stringUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        parser = XMLParser(contentsOf: url!)!
        parser.delegate = self
        parser.parse()
        
        tableview.reloadData()
    }
}
extension SearchViewController {
    
    func initPages() -> UINavigationController {
        let vc = StoryboardScene.Search.searchViewController.instantiate()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    // 開始タグ
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        self.currentElementName = nil
        if elementName == "item" {
//            self.pages.append(Page(_id: "", url: "", title: "", thumbnail: "", timestamp: Date(), site_name: "", description: ""))
            self.pages.append(Feed())
        } else {
            currentElementName = elementName
        }
    }
    
    // 開始タグと終了タグの間にデータが存在した時
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.pages.count > 0 {
            var lastItem = self.pages[self.pages.count - 1]
            switch self.currentElementName {
            case "title":
                let tmpString = lastItem.title
                lastItem.title = (tmpString != nil) ? tmpString! + string : string + ""
                break
            case "link":
                lastItem.url = string + ""
                if let component: NSURLComponents = NSURLComponents(string: lastItem.url) {
                    lastItem.site_name = component.host
                }
                break
            case "description":
                let tmpString = lastItem.description
                lastItem.description = (tmpString != nil) ? tmpString! + string : string + ""
                break
            case "content:encoded":
                let pattern = "(https://cdn-ak-scissors.b.st-hatena.com/image/square/.+?.(jpg|png|jpeg|JPG|JPEG|PNG|gif))"
                let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                let matches = regex.matches(in: string, options: [], range: NSMakeRange(0, string.count))
                
                var results: [String] = []
                if (matches.count <= 0) {
                    break
                }
                matches.forEach { (match) -> () in
                    results.append( (string as NSString).substring(with: match.range(at: 1)) )
                }
                
                lastItem.thumbnail = (results.count > 0) ? results[0] : ""
                if (results.count > 0) {
                    print(lastItem.thumbnail)
                }
                break
            case "dc:date":
                lastItem.timestamp = Date(fromIOS8601_2: string)
                break
            case "hatena:bookmarkcount":
                lastItem.score = 2 + string.count
                break
            default: break
            }
        }
    }
    
    // 終了タグ
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentElementName = nil
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableview.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let article = articles[indexPath.row]
        let page = pages[indexPath.row]
        let article = Article(_id: page.url, page: Page(_id: page.url, url: page.url, title: page.title, thumbnail: page.thumbnail, timestamp: page.timestamp, site_name: page.site_name, description: page.description), category: Category(_id: "", name: ""), score: page.score)
        guard let nc = self.navigationController else {
            return
        }
        let p = HistoryObject(p:article.page)
        p.page?.score = article.score
        p.page?.category = article.category.name
        RealmManager.addEntity(object: p)
        WebViewUtil.showWKWebView(article: article, from: nc, disAppear: {})
        
    }
    
    private func saveCache(article: Article) {
        let p = PageObject(page:article.page)
        p.score = article.score
        p.category = article.category.name
        RealmManager.addEntity(object: p)
        guard let url = NSURL(string: article.page.url) else {
            return
        }
        let cache = URLCache.shared
        let data = NSData.init(contentsOf: url as URL)
        let urlResponse = URLResponse(url: url as URL,
                                      mimeType: "text/html",
                                      expectedContentLength: 0,
                                      textEncodingName: "UTF-8")
        let response = CachedURLResponse.init(response: urlResponse, data: data! as Data, userInfo: nil, storagePolicy: .allowed)
        let request = NSURLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0) as URLRequest?
        //        let request = NSURLRequest(url: url as URL) as URLRequest?
        let mutableRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "", in: mutableRequest)
        let myrequest = mutableRequest as URLRequest
        cache.storeCachedResponse(response, for: myrequest)
        showToast(message: "Bookmarked!")
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pages.count == 0 {
            self.tableview.setEmptyMessage("気になるキーワードをチェックしましょう")
        } else {
            self.tableview.restore()
        }
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//        let page = self.pages[indexPath.row]
//        cell.textLabel?.text = page.thumbnail
//        return cell
        
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.samune.image = nil
        let page = self.pages[indexPath.row]
        let article = Article(_id: "", page: Page(_id: "", url: page.url, title: page.title, thumbnail: page.thumbnail, timestamp: page.timestamp, site_name: page.site_name, description: page.description), category: Category(_id: "", name: ""), score: page.score)
        cell.setupArticle(article)
        //        let longPress =
        //            UILongPressGestureRecognizer(target: self, action: Selector("cellLongPressed:"))
        //        cell.addGestureRecognizer(longPress);
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    private func setupRecognizer() {
        longPressRecognizer.delegate = self
        tableview.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let isAllow = UserDefaults.standard.bool(forKey: "longPress")
        if (!isAllow) {
            return
        }
        if (!CheckReachability(host_name: "google.com")) {
            return
        }
        
        let point = recognizer.location(in: tableview)
        let indexPath = tableview.indexPathForRow(at: point)
        let page = self.pages[(indexPath?.row)!]
        let article = Article(_id: "", page: Page(_id: "", url: page.url, title: page.title, thumbnail: page.thumbnail, timestamp: page.timestamp, site_name: page.site_name, description: page.description), category: Category(_id: "", name: ""), score: page.score)
//        let article = articles[(indexPath?.row)!]
        
        if recognizer.state == UIGestureRecognizerState.began {
            saveCache(article: article)
        }
    }
}

private extension Selector {
    
    static let cellLongPressed = #selector(SearchViewController.cellLongPressed(recognizer:))
}

