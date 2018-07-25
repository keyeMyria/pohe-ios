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
    
    struct GetWeatherRequest: WeatherRequest {
        typealias Response = Weather
        
        private let lat: String
        private let lon: String
        
        init(lat: String, lon: String) {
            self.lat = lat
            self.lon = lon
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return ""
        }
        
        var queryParameters: [String : Any]? {
            var parameter =  ["lat": lat, "lon": lon, "appid": "8cffa34c88a7d28b0dc400762f593494"]
            return parameter
        }
        
    }
    
    struct GetLocationRequest: LocationRequest {
        typealias Response = Location
        
        private let x: String
        private let y: String
        
        init(x: String, y: String) {
            self.x = x
            self.y = y
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return ""
        }
        
        var queryParameters: [String : Any]? {
            var parameter =  ["x": x, "y": y, "method": "searchByGeoLocation"]
            return parameter
        }
        
    }
        
}

