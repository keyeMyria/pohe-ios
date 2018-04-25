//
//  Article.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation

struct Article: Codable {
    let _id: String
    let page: Page
    
    private enum CodingKeys: String, CodingKey {
        case _id
        case page
    }
    
}
