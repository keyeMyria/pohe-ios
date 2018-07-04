//
//  RealmManager.swift
//  pohe-ios
//
//

import Foundation
import RealmSwift

class RealmManager {
    
    static func addEntity<T: Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    static func deleteEntity<T: Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
            realm.delete(object)
        }
    }
    
    static func getEntityList<T: Object>(type: T.Type) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(type.self)
    }
    
    static func filterEntityList<T: Object>(type: T.Type, property: String, filter: Any) -> Results<T> {
        return getEntityList(type: type).filter("%K == %@", property, String(describing: filter))
    }
    
}
