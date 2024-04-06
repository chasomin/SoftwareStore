//
//  Software.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import Foundation

struct Store: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let artworkUrl512: String
    let screenshotUrls: [String]
    let trackName: String
    let trackViewUrl: String
    let contentAdvisoryRating: String
    let formattedPrice: String
    let artistName: String
    let genres:[String]
    let price: Double
    let description: String
    let version: String
}

