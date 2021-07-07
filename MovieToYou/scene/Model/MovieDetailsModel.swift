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
    var results: [Results]
}

struct Results: Codable {
    var poster_path: String?
    var original_title: String?
    var release_date: String?
    var genre_ids: [Int]?
}

//List of genre from API /genre/movie/list
let movieGenres = [28: "Action",12: "Adventure", 16: "Animation", 35: "Comedy", 80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family", 14: "Fantasy", 36: "History", 27: "Horror", 10402: "Music", 9648 : "Mystery", 10749: "Romance", 878: "Science Fiction", 10770: "TV Movie", 53: "Thriller", 10752: "War", 37: "Western"]
