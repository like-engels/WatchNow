//
//  MovieModel.swift
//  WatchNow
//
//  Created by User-D on 7/21/22.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var mediaType: String?
    var originalName: String?
    var originalTitle: String?
    var posterPath: String?
    var overview: String?
    var voteCount: Int
    var releaseDate: String?
    var voteAverage: Double?
    
    private enum CodingKeys: String, CodingKey  {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        
    }
}

struct Movies: Codable {
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
