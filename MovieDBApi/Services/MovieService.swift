//
//  MovieService.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import Foundation
import Combine

final class MovieService {
  static let shared = MovieService()
  private init () { }
  private let apiKey = "5b8ac4a0ff1e761a36f23ce79e61e35c"
  private let apiVersion = "3"
  private let urlString = "https://api.themoviedb.org"
  private let imageUrlString = "https://image.tmdb.org/t/p/w500"
  
  enum ApiMethods: String {
    case weeklyTrendingMovies = "/trending/movie/week"
    case searchMovie = "/search/movie"
  }
  
  func createURL(for method: ApiMethods, query: String? = nil, page: UInt? = nil) -> URL? {
    guard var urlComponents = URLComponents(string: urlString) else { return nil }
    urlComponents.path = "/\(apiVersion)\(method.rawValue)"
    let apiKeyItem = URLQueryItem(name: "api_key", value: apiKey)
    urlComponents.queryItems = [apiKeyItem]
    
    if let queryValue = query {
      let query = URLQueryItem(name: "query", value: queryValue)
      urlComponents.queryItems?.append(query)
    }
    
    if let page = page {
      let query = URLQueryItem(name: "page", value: "\(page)")
      urlComponents.queryItems?.append(query)
    }
    
    let result = urlComponents.url
    return result
  }
  
  func getMovies(with url: URL?) -> AnyPublisher<MovieResponse, Never> {
    guard let url = url else { return Just (MovieResponse(movies: [Movie()])).eraseToAnyPublisher() }
    return URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: MovieResponse.self, decoder: JSONDecoder())
      .catch { _ in Empty<MovieResponse, Never>() }
      .map { responce -> MovieResponse in
        return MovieResponse(
          pages: responce.pages,
          movies: responce.movies.map { movie -> Movie in
            var newValue = movie
            newValue.poster_path = self.imageUrlString + (movie.poster_path ?? "")
            return newValue
          })
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
