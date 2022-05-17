//
//  PopularMoviesCollectionViewCell.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import UIKit
import SnapKit

class PopularMoviesCollectionViewCell: UICollectionViewCell {
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configure() {
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  }
}

