//
//  MainViewModel.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import Foundation
import Combine

extension ViewController {
  final class ViewModel {
    private let movieService = MovieService.shared
    @Published var query: String
    @Published var page: UInt = 1
    @Published private(set) var movies: [Movie]
    var pagesCount = 0
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
      self.movies = [Movie]()
      self.query = "The lord of"
      makeSubscribers()
    }
    
    private func makeSubscribers() {
      $query
        .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
        .sink { [weak self] query in
          guard let self = self else { return }
          self.page = 1
        }
        .store(in: &subscriptions)
      
      $page
        .dropFirst()
        .sink { [weak self] page in
          guard let self = self else { return }
          self.getMovies(page: page)
        }
        .store(in: &subscriptions)
    }

    private func getMovies(page: UInt) {
      let url = movieService.createURL(for: .searchMovie, query: query, page: page)
      movieService.getMovies(with: url)
        .sink { [weak self] responce in
          guard let self = self else { return }
          if self.page > 1 {
            self.movies.append(contentsOf: responce.movies)
          } else {
            self.movies = responce.movies
          }
          self.pagesCount = responce.pages ?? 0
        }
        .store(in: &subscriptions)
    }
  }
}

