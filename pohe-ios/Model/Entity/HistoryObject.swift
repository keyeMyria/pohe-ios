//
//  History.swift
//  pohe-ios
//
import Foundation
import Realm
import RealmSwift

@objcMembers
class HistoryObject: Object {
    
    dynamic var id: String = NSUUID().uuidString
    dynamic var page: PageObject?
    dynamic var createAt: Date?

    convenience init(p: Page) {
        self.init()
        self.page = PageObject(page: p)
        self.createAt = Date()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func fromObject(page: PageObject) -> Page {
        return Page.init(
            _id: page._id,
            url: page.url,
            title: page.title,
            thumbnail: page.thumbnail,
            timestamp: Date(),
            site_name: page.site_name,
            description: page.description
        )
    }
 }
