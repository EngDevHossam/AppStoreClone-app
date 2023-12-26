//
//  SearchResult.swift
//  AppStoreMockInterview
//
//  Created by Brian Voong on 12/25/23.
//

import Foundation

// trackName trackId artistName primaryGenreName screenshotUrls artworkUrl512

struct SearchResult: Codable {
    let results: [Result]
}

struct Result: Codable, Identifiable {
    
    var id: Int { trackId }
    
    let trackId: Int
    let trackName: String
    let artworkUrl512: String
    let primaryGenreName: String
    let screenshotUrls: [String]
    let averageUserRating: Double
    let userRatingCount: Int
}
