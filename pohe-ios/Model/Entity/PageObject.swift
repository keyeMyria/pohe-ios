//
//  PageObject.swift
//  pohe-ios
//
//

import Foundation
import Realm
import RealmSwift

@objcMembers
class PageObject: Object {
    
    dynamic var _id = ""
    dynamic var title = ""
    dynamic var url = ""
    dynamic var thumbnail = ""
    dynamic var timestamp: Date?
    dynamic var site_name = ""
    
    convenience init(page: Page) {
        self.init()
        
        _id = page._id
        title = page.title
        url = page.url
        thumbnail = page.thumbnail ?? ""
        timestamp = page.timestamp
        site_name = page.site_name ?? ""
        
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
