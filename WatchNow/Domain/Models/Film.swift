//
//  Films.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 11/3/23.
//

import Foundation

struct Film {
    let id: Int
    var mediaType: String?
    var originalName: String?
    var originalTitle: String?
    var posterPath: String?
    var overview: String?
    let voteCount: Int
    var releaseDate: String?
    var voteAverage: Double?
    
    static func fromJsonDict(dict: [String: Any]) -> Film {
        Film(
            id: dict["id"] as! Int,
            originalName: dict["original_name"] as? String,
            originalTitle: dict["original_title"] as? String,
            posterPath: dict["poster_path"] as? String,
            overview: dict["overview"] as? String,
            voteCount: dict["vote_count"] as! Int,
            releaseDate: dict["release_date"] as? String,
            voteAverage: dict["vote_average"] as? Double
        )
    }
}
