//
//  Page.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/24.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation

struct Page: Codable {
    var _id: String
    var url: String
    var title :String
    var thumbnail: String?
    var timestamp: Date?
    var site_name: String?
    var description: String?


    public enum CodingKeys: String, CodingKey {
        case _id
        case url
        case title
        case thumbnail = "thumbnail"
        case timestamp
        case site_name = "site_name"
        case description

    }
    
}
