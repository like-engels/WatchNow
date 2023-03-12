//
//  Trailer.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 11/3/23.
//

import Foundation

struct Trailer {
    let id: TrailerId
    
    struct TrailerId {
        let kind: String
        let videoId: String
        
        static func fromJsonDict(dict: [String: String]) -> TrailerId {
            TrailerId(
                kind: dict["kind"]!,
                videoId: dict["videoId"]!
            )
        }
    }
    
    static func fromJsonDict(dict: [String: String]) -> Trailer {
        Trailer(id: TrailerId.fromJsonDict(dict: dict))
    }
}
