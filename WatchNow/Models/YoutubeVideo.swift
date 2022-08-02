//
//  YoutubeVideoModel.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 24/7/22.
//

import Foundation

struct TrailerVideo: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id: YoutubeVideoIdentifier
    
}

struct YoutubeVideoIdentifier: Codable {
    let kind: String
    let videoId: String
}
