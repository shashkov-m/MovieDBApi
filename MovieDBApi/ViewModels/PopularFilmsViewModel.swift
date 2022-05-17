//
//  PopularFilmsViewModel.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import UIKit
import Combine

extension PopularMoviesCollectionView {
  final class ViewModel {
    private let movieService = MovieService.shared
    @Published private(set) var movies: [Movie]
    var subscriptions = Set<AnyCancellable>()
    
    init() {
      self.movies = [Movie]()
      getMovies()
    }
    
    func createLayout() -> UICollectionViewLayout {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .fractionalHeight(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      let layout = UICollectionViewCompositionalLayout(section: section)
      return layout
    }
    
    private func getMovies() {
      let url = movieService.createURL(for: .weeklyTrendingMovies)
      movieService.getMovies(with: url)
        .sink { [weak self] response in
          guard let self = self else { return }
          self.movies = response.movies
        }
        .store(in: &subscriptions)
    }
  }
}

