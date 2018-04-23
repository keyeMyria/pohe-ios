//
//  RequestType.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import Foundation
import APIKit

struct RestError: Error {
    let message: String
    
    init(object: AnyObject) {
        message = object["message"] as? String ?? "Unknown Error"
    }
}

protocol RestRequest: Request {
}

extension RestRequest {
    
    var headerFields: [String: String] {
//        let accessToken = AccessTokenStorage.fetchAccessToken()
//        if accessToken.isEmpty {
//            return [:]
//        }
        return [:]
//        return ["Authorization": "Bearer \(accessToken)"]
    }
    
    var baseURL: URL {
        return URL(string: "http://menthas.com")!
    }
    
    var dataParser: DataParser {
        return JSONDataParser(readingOptions: [])
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200..<300:
            return object
        case 400, 401, 402, 403, 404:
            throw RestError(object: object as AnyObject)
        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }
    
}

extension RestRequest where Response: Codable {
    
    var dataParser: DataParser {
        return CodableParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
    
}

extension RestRequest where Response: Codable, Response: Sequence, Response.Element: Codable {
    
    var dataParser: DataParser {
        return CodableParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
    
}

extension RestRequest where Response == Void {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Void {
        return ()
    }
    
}

class CodableParser: DataParser {
    // MARK: - DataParser
    
    /// Value for `Accept` header field of HTTP request.
    public var contentType: String? {
        return "application/json"
    }
    
    /// Return `Any` that expresses structure of JSON response.
    /// - Throws: `NSError` when `JSONSerialization` fails to deserialize `Data` into `Any`.
    public func parse(data: Data) throws -> Any {
        return data
    }
}
