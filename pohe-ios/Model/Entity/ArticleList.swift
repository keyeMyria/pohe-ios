//
//  ArticleList.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/24.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//


import Foundation

struct ArticleList: Codable {
    let items: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
}
