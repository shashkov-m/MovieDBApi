//
//  PopularMoviesCollectionView.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import UIKit
import Kingfisher
import Combine

class PopularMoviesCollectionView: UICollectionView {
  let viewModel = ViewModel()
  var subscriptions = Set<AnyCancellable>()
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  init() {
    let layout = viewModel.createLayout()
    super.init(frame: .zero, collectionViewLayout: layout)
    configure()
  }
  
  private func configure() {
    self.dataSource = self
    self.isScrollEnabled = false
    self.register(PopularMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    viewModel.$movies
      .sink(receiveValue: { [weak self] _ in
        DispatchQueue.main.async {
          self?.reloadData()
        }
      })
      .store(in: &subscriptions)
  }
  
}

extension PopularMoviesCollectionView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PopularMoviesCollectionViewCell
    let movie = viewModel.movies[indexPath.item]
    if let path = movie.poster_path {
      let url = URL(string: path)
      cell.imageView.kf.setImage(with: url)
    }
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
}

