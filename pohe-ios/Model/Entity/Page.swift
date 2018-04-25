//
//  Page.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/24.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation

struct Page: Codable {
    let _id: String
    let url: String
    let title :String
    let thumbnail: String?

    public enum CodingKeys: String, CodingKey {
        case _id
        case url
        case title
        case thumbnail = "thumbnail"
    }
    
}
