//
//  Model.swift
//  PublicAPI
//
//  Created by Unsal Oner on 7.02.2023.
//

import Foundation

// MARK: - API
struct API: Codable {
    let count: Int
    let entries: [Entry]
}

// MARK: - Entry
struct Entry: Codable {
    let api, description: String
    let auth: Auth
    let https: Bool
    let cors: Cors
    let link: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}

enum Auth: String, Codable {
    case apiKey = "apiKey"
    case empty = ""
    case oAuth = "OAuth"
    case userAgent = "User-Agent"
    case xMashapeKey = "X-Mashape-Key"
}

enum Cors: String, Codable {
    case no = "no"
    case unknown = "unknown"
    case unkown = "unkown"
    case yes = "yes"
}
