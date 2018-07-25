//
//  Location.swift
//  pohe-ios
//
struct Location: Codable {
    var response: Res
}

struct Res: Codable {
    let location: [LocationContent]
}

struct LocationContent: Codable {
    let city: String
    let town: String
}



