//
//  MovieDetailsViewController.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
  let movie: Movie
  let posterImageView = UIImageView()
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let releaseDateLabel = UILabel()
  
  init(_ movie: Movie) {
    self.movie = movie
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  private func configure() {
    setupConstraints()
    view.backgroundColor = .white
    titleLabel.font = .systemFont(ofSize: 18)
    titleLabel.numberOfLines = 0
    descriptionLabel.font = .systemFont(ofSize: 14)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textAlignment = .justified
    releaseDateLabel.font = .systemFont(ofSize: 12)
    releaseDateLabel.textColor = .systemGray2
    releaseDateLabel.numberOfLines = 1
    posterImageView.contentMode = .scaleAspectFill
    titleLabel.text = movie.title
    descriptionLabel.text = movie.overview
    releaseDateLabel.text = movie.release_date
    if let path = movie.poster_path, let url = URL(string: path) {
      posterImageView.kf.setImage(with: url)
    }
  }
  
  private func setupConstraints() {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    let VStack = UIStackView(arrangedSubviews: [titleLabel, posterImageView, releaseDateLabel, descriptionLabel])
    VStack.axis = .vertical
    VStack.distribution = .fill
    VStack.alignment = .center
    VStack.spacing = 12
    scrollView.addSubview(VStack)
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    posterImageView.snp.makeConstraints { make in
      make.width.equalTo(200)
      make.height.equalTo(300)
    }
    VStack.snp.makeConstraints { make in
      make.left.equalTo(scrollView).inset(20)
      make.top.equalTo(scrollView).inset(20)
      make.width.equalTo(view.snp.width).inset(20)
      make.right.equalTo(scrollView.snp.right)
      make.bottom.equalTo(scrollView.snp.bottom).inset(20)
    }
  }
}

