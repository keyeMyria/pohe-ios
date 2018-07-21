//
//  Category.swift
//  pohe-ios
//
import Foundation

struct Category: Codable {
    let _id: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case _id
        case name
    }
    
}
