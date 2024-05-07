//
//  Movie.swift
//  day7-CoreData2
//
//  Created by Mina on 01/05/2024.
//

import Foundation

struct Movie: Codable {
    var genre: String?
    var img: Data?
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var id: Int?
    var originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(title: String, genre: String, releaseDate: String, voteCount: Int, img: Data) {
        self.title = title
        self.originalTitle = title
        self.genre = genre
        self.releaseDate = releaseDate
        self.voteCount = voteCount
        self.img = img
    }
}

struct Movies: Codable {
    var page: Int?
    var results: [Movie]?
    var totalPages, totalResults: Int?
    enum CodingKeys: String, CodingKey {
            case page, results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    
}

struct GenreRequest: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

let genres: [Int: String] = [
          28: "Action",
          12: "Adventure",
          16: "Animation",
          35: "Comedy",
          80: "Crime",
          99: "Documentary",
          18: "Drama",
          10751: "Family",
          14: "Fantasy",
          36: "History",
          27: "Horror",
          10402: "Music",
          9648: "Mystery",
          10749: "Romance",
          878: "Science Fiction",
          10770: "TV Movie",
          53: "Thriller",
          10752: "War",
          37: "Western"
      ]


