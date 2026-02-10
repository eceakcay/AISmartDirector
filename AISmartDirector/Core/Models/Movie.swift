//
//  Movie.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 6.02.2026.
//

import Foundation

struct MovieResponse : Codable {
    let results: [Movie]
}

struct Movie: Codable, Hashable, Sendable {
    let id : Int
    let title: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
