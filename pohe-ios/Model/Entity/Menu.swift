//
//  Menu.swift
//  pohe-ios
//

import Foundation
struct Menus: Codable {
    var mainItems: [Menu]
    var subItems: [Menu]
    
    private enum CodingKeys: String, CodingKey {
        case mainItems = "Main"
        case subItems = "Sub"
    }
}
struct Menu: Codable {
    
    public enum SubLabelType: String {
        case none
        case version
    }

    let name: String?
    let iconImageName = ""
    let hasSegue = true
    let segueIdentifier: String?
    let url: URL?
    let subLabelType: String?

    
    private enum CodingKeys: String, CodingKey {
        case name
        case iconImageName
        case hasSegue
        case segueIdentifier
        case url
        case subLabelType
    }
    
    public static func map() -> [Menu] {
        if let source = FileUtil.loadPlistData(plistFileName: "Menu") {
            let decoder = PropertyListDecoder()
            if let menus = try? decoder.decode(Menus.self, from: source) {
                return menus.mainItems
            }
        }
        return []
    }
    
    public static func mapSub() -> [Menu] {
        if let source = FileUtil.loadPlistData(plistFileName: "Menu") {
            let decoder = PropertyListDecoder()
            if let menus = try? decoder.decode(Menus.self, from: source) {
                return menus.subItems
            }
        }
        return []
    }
    
}
