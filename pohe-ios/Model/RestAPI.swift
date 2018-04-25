//
//  RestApi.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import APIKit

final class RestAPI {
    
    init() {
    }
    
    struct GetArticlesRequest: RestRequest, PaginationRequest {
        typealias Response = ArticleList
        
        var offset: Int
        private let category: String
        
        init(category: String, offset: Int = 0) {
            self.offset = offset
            self.category = category
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/\(category)/list"
        }
        
        var queryParameters: [String : Any]? {
            var parameter =  ["offset": offset]
            return parameter
        }
        
    }
        
}

