//
//  StringExtension.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/25.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
public extension String {
    static func makeTemp(temp: Float) -> String {
        return String(format: "%.1f", temp - 273.15)
    }
}
