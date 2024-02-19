//
//  ReviewResults.swift
//  AppStoreMockInterview
//
//  Created by Brian Voong on 12/26/23.
//

import Foundation

struct ReviewResults: Codable {
    let feed: ReviewFeed
}

struct ReviewFeed: Codable {
    let entry: [Review]
}

struct Review: Codable, Identifiable {
    var id: String { content.label }
    let content: JSONLabel
    let title: JSONLabel
    let author: Author
    
    let rating: JSONLabel
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case content
        
        case rating = "im:rating"
    }
    
//    let im:rating: JSONLabel
}

struct Author: Codable {
    let name: JSONLabel
}

struct JSONLabel: Codable {
    let label: String
}

//{
//  "feed": {
//    "author": {
//      "name": { "label": "iTunes Store" },
//      "uri": { "label": "http://www.apple.com/itunes/" }
//    },
//    "entry": [
//      {
//        "author": {
//          "uri": {
//            "label": "https://itunes.apple.com/us/reviews/id1295716811"
//          },
//          "name": { "label": "idswim" },
//          "label": ""
//        },
//        "updated": { "label": "2023-12-25T05:37:36-07:00" },
//        "im:rating": { "label": "1" },
//        "im:version": { "label": "14.24.2" },
//        "id": { "label": "10743046471" },
//        "title": { "label": "Banned for no reason" },
//        "content": {
//          "label": "I was sent a notification that my account was banned for being too active when I hadn’t even been on it for a few days. So, unless I was hacked, it makes zero sense.",
//          "attributes": { "type": "text" }
//        },
//        "link": {
//          "attributes": {
//            "rel": "related",
//            "href": "https://itunes.apple.com/us/review?id=547702041&type=Purple%20Software"
//          }
//        },
//        "im:voteSum": { "label": "0" },
//        "im:contentType": {
//          "attributes": { "term": "Application", "label": "Application" }
//        },
//        "im:voteCount": { "label": "0" }
//      },
