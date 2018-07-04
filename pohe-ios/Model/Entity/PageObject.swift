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
    
    convenience init(page: Page) {
        self.init()
        
        _id = page._id
        title = page.title
        url = page.url
        thumbnail = page.thumbnail ?? ""
        
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
