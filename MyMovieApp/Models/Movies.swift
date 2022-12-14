//
//  Movies.swift
//  MyMovieApp
//
//  Created by Simon LE on 27/07/2022.
//

import Foundation


struct Movies: Decodable {
    let results: [Movie]
}

extension Movies {
    enum codingKeys: String, CodingKey {
        case results = "results"
    }
}

struct Movie: Codable {
    let id: Int?
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let popularity: Double?
    let release_date: String?
    let vote_average: Double?
    let poster: String?
    let backdrop_path: String?
    let title: String?
    let name: String?
    let runtime: Int?
    
    init(id: Int?, media: String?, language: String?, original_title: String?, poster_path: String?, overview: String?, popularity: Double?, release_date: String?, vote_average: Double?, poster: String?, backdrop_path: String?, title: String?, name: String?, runtime: Int?) {
        self.id = id
        self.media_type = media
        self.original_language = language
        self.original_title = original_title
        self.poster_path = poster_path
        self.overview = overview
        self.popularity = popularity
        self.release_date = release_date
        self.vote_average = vote_average
        self.poster = poster
        self.backdrop_path = backdrop_path
        self.title = title
        self.name = name
        self.runtime = runtime
    }
    
    var backdropURL: String {
        return ("https://image.tmdb.org/t/p/w500\(backdrop_path ?? "")")
    }
    
    var posterURL: String {
        return ("https://image.tmdb.org/t/p/w500\(poster_path ?? "")")
    }
}

struct MovieGenre: Decodable {
    let name: String
}


struct Identification: Decodable {
    let results: [Infos]
}

struct Infos: Decodable {
    let name: String?
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
    let id: String?
}

struct MovieCredit: Decodable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Decodable {
    let id: Int
    let character: String
    let name: String
}

struct MovieCrew: Decodable {
    let name: String
    let job: String
    
}

var favorites = [Movie]()


