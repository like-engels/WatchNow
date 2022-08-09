//
//  YoutubeVideoModel.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 24/7/22.
//

import Foundation

struct TrailerVideo: Codable {
    var items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    var id: YoutubeVideoIdentifier
    
}

struct YoutubeVideoIdentifier: Codable {
    var kind: String
    var videoId: String
}
