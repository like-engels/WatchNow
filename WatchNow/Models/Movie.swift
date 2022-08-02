//
//  MovieModel.swift
//  WatchNow
//
//  Created by User-D on 7/21/22.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double?
}

struct Movies: Codable {
    let results: [Movie]
}
