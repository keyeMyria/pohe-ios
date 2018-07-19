//
//  Pods.swift
//  pohe-ios
//
import Foundation
struct Licenses: Codable {
    var items: [License]
    
    private enum CodingKeys: String, CodingKey {
        case items = "PreferenceSpecifiers"
    }
}

struct License: Codable {
    var title: String?
    var footerText: String?
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case footerText = "FooterText"
    }
    
    public static func map() -> [License] {
        if let source = FileUtil.loadPlistData(plistFileName: "Settings.bundle/Acknowledgements") {
            let decoder = PropertyListDecoder()
            let licenses = try? decoder.decode(Licenses.self, from: source)
            if let items = licenses?.items {
                return items
            }
        }
        return []
    }
}

//struct LicenseDetails: Codable {
//    var items: [LicenseDetail]
//    
//    private enum CodingKeys: String, CodingKey {
//        case items = "PreferenceSpecifiers"
//    }
//}
//
//struct LicenseDetail: Codable {
//    var body: String
//    
//    private enum CodingKeys: String, CodingKey {
//        case body = "FooterText"
//    }
//}
