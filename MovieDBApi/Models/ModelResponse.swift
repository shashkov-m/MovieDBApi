//
//  ModelResponse.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import Foundation

struct MovieResponse: Codable {
  var pages: Int?
  var movies: [Movie]
  
  enum CodingKeys: String, CodingKey {
    case pages = "total_pages"
    case movies = "results"
  }
}

struct Movie: Codable {
  var overview: String?
  var poster_path: String?
  var title: String?
  var release_date: String?
  var id: Int?
}
