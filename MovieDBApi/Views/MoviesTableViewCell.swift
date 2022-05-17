//
//  MoviesTableViewCell.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import UIKit
import SnapKit

class MoviesTableViewCell: UITableViewCell {
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let releaseDateLabel = UILabel()
  let posterImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configure() {
    titleLabel.font = .systemFont(ofSize: 18)
    titleLabel.numberOfLines = 2
    descriptionLabel.font = .systemFont(ofSize: 14)
    descriptionLabel.numberOfLines = 4
    releaseDateLabel.font = .systemFont(ofSize: 12)
    releaseDateLabel.textColor = .systemGray2
    releaseDateLabel.numberOfLines = 1
    posterImageView.contentMode = .scaleAspectFill
    posterImageView.clipsToBounds = true
  }
  
  private func setupConstraints() {
    let VStack = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel, descriptionLabel])
    VStack.axis = .vertical
    VStack.distribution = .fill
    VStack.alignment = .top
    VStack.spacing = 6
    let HStack = UIStackView(arrangedSubviews: [posterImageView, VStack])
    HStack.axis = .horizontal
    HStack.distribution = .fill
    HStack.spacing = 10
    HStack.alignment = .leading
    contentView.addSubview(HStack)
    HStack.snp.makeConstraints { make in
      make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    posterImageView.snp.makeConstraints { make in
      make.height.equalTo(160)
      make.width.equalTo(120)
    }
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    posterImageView.image = nil
  }
}

