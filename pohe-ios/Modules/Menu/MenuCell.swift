//
//  MenuCell.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/09.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    static let cellID = "MenuCell"
    let list = ["longPress", "pushNotification"]
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBAction func handleSwitch(_ sender: Any) {
        UserDefaults.standard.set(switchView.isOn, forKey: list[self.tag])
        print(UserDefaults.standard.bool(forKey: list[self.tag]))
        print(list[self.tag])
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
            switchView.isHidden = false
            switchView.tag = 1
        }
    }

}
