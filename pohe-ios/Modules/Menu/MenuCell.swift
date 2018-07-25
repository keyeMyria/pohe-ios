//
//  MenuCell.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/09.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import UserNotifications


class MenuCell: UITableViewCell {
    static let cellID = "MenuCell"
    let list = ["weather", "longPress", "pushNotification"]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBAction func handleSwitch(_ sender: UISwitch) {
        switch(sender.tag) {
        case 0:
            UserDefaults.standard.set(switchView.isOn, forKey: list[self.tag])
            break
        case 1:
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            break
        default:
            break
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func configure(entity: Menu) {
        
        titleLabel.text = entity.name
        if entity.subLabelType == Menu.SubLabelType.version.rawValue {
            version.text = AppInfoUtil.bundleShortVersionString()
        }
        if entity.subLabelType == "longPress" {
            switchView.tag = 0
            switchView.isOn = UserDefaults.standard.bool(forKey: list[0])
            switchView.isHidden = false
        }
        if entity.subLabelType == "pushNotification" {
            switchView.isEnabled = true
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                self.switchView.isOn = (settings.authorizationStatus == .authorized)
            }
            switchView.tag = 1
            switchView.isEnabled = false
//            switchView.color
            switchView.isHidden = false
        }
//        if entity.subLabelType == "weather" {
//            updateWeather()
//        }
    }
    
    
}


