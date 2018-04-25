//
//  PaginationRequest.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import APIKit

protocol PaginationRequest: Request {
    var offset: Int { get set }
}
