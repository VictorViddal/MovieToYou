//
//  MovieDetailsModel.swift
//  MovieToYou
//
//  Created by Victor Vidal on 02/07/21.
//

import Foundation

struct MovieDetails: Codable {
    var original_title: String?
    var vote_count: Int?
    var popularity: Double?
    var poster_path: String?

}
struct SimilarMovies: Codable {
    var results: [Result]
}

struct Result: Codable {
    var poster_path: String?
    var original_title: String?
    var release_date: String?
    var genre_ids: [Int]?
}
