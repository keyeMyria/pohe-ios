//
//  MenuViewController.swift
//  pohe-ios
//
import UIKit
import RxSwift
import RxCocoa
import MessageUI
import WebKit

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
//            tableView.dataSource = self
//            tableView.register(R.nib.etcCell)
//            tableView.register(R.nib.etcWeatherCell)
        }
    }
    @IBOutlet weak var cancel: UIBarButtonItem!
    private let disposeBag = DisposeBag()
    private let list: [[Menu]] = [Menu.mapSub(), Menu.map()]
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillEnterForeground, object: nil)
            .subscribe(onNext: { [weak self] in
                self?.viewWillEnterForeground($0)
            }).disposed(by: disposeBag)

        
        setup()
    }
    
    func viewWillEnterForeground(_ notification: Notification?) {
        tableView.reloadRows(at: [IndexPath(item: 2, section: 0)], with: .none)
    }
    
    
    func setup() {
        tableView.register(UINib(nibName: MenuCell.cellID, bundle: nil), forCellReuseIdentifier: MenuCell.cellID)
        tableView.register(UINib(nibName: WeatherCell.cellID, bundle: nil), forCellReuseIdentifier: WeatherCell.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        cancel.rx.tap.subscribe(onNext: {[weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setupMail() {
        guard MFMailComposeViewController.canSendMail() else { return }
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["eccentricyan@gmail.com"])
//        mailComposeViewController.setCcRecipients(["test2@test.com"])
//        mailComposeViewController.setBccRecipients(["test3@test.com"])
        mailComposeViewController.setSubject("不具合報告")
        mailComposeViewController.setMessageBody("pohe-ios の不具合がありました。\n発生した事象:\n\n\n\n\n--\npohe-ios: \(AppInfoUtil.bundleShortVersionString())\niOS: \(UIDevice.current.systemVersion)\n\(AppInfoUtil.getDeviceInfo())", isHTML: false)
        present(mailComposeViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("cancelled")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        case .failed:
            print("failed")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeCache() {
//        override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
//            if event?.type == .motion && event?.subtype == .motionShake {
                let alert = UIAlertController(title: "確認", message: "キャッシュをすべて削除しますか？", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.remove()
                }))
                alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    func remove() {
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
    }
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let entity = list[indexPath.section][indexPath.row]
        if (indexPath.section == 0 && indexPath.row == 0) {
//            cell.delegate = self
//            return cell
            cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
            (cell as! WeatherCell).delegate = self
            
            (cell as! WeatherCell).configure(entity: entity)
        } else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            
            (cell as! MenuCell).configure(entity: entity)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let entity = list[indexPath.section][indexPath.row]
        
        guard let nextIdentifier = entity.segueIdentifier, entity.subLabelType != Menu.SubLabelType.version.rawValue else { return }
        switch nextIdentifier {
        case StoryboardSegue.Menu.showOpenSource.rawValue:
            perform(segue: StoryboardSegue.Menu.showOpenSource)
        case "mail":
            setupMail()
        case "removeCache":
            removeCache()
        case "history":
            perform(segue: StoryboardSegue.Menu.showHistory)
        case "longPress":
            break
        case "weather":
            break
        case "pushNotification":
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        default:
            performSegue(withIdentifier: entity.segueIdentifier!, sender: nil)
            break
        }
        
    }

}

extension MenuViewController: WeatherCellDelegate {
    func updateFinished(cell: WeatherCell, result: Bool) {
        if result {
            tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none)
        }
    }
    
    
    func initPages() -> UINavigationController {
        let vc = StoryboardScene.Menu.menuViewController.instantiate()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }

}

