//
//  ViewController.swift
//  MovieDBApi
//
//  Created by Max Shashkov on 17.05.2022.
//

import UIKit
import Kingfisher
import Combine

class ViewController: UIViewController {
  private let popularFilmsCollectionView = PopularMoviesCollectionView()
  private let tableView = UITableView()
  private let viewModel = ViewModel()
  private var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSearchBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configure()
  }
  
  private func configure() {
    configureUI()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: "cell")
    title = "Movies"
    navigationController?.navigationBar.prefersLargeTitles = false
    viewModel.$movies
      .sink { [weak self] _ in
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
      .store(in: &subscriptions)
  }
  
  private func configureUI() {
    view.backgroundColor = .white
    let stack = UIStackView(arrangedSubviews: [popularFilmsCollectionView, tableView])
    stack.axis = .vertical
    stack.distribution = .fill
    stack.alignment = .fill
    stack.spacing = 10
    view.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.left.equalTo(view)
      make.right.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    popularFilmsCollectionView.snp.makeConstraints { make in
      make.height.equalTo(200)
    }
  }
  
  private func configureSearchBar() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search a movie"
    searchController.searchBar.text = viewModel.query
    searchController.searchResultsUpdater = self
    searchController.searchBar.addDoneButtonOnKeyboard()
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.movies.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesTableViewCell
    let movie = viewModel.movies[indexPath.row]
    cell.titleLabel.text = movie.title
    cell.descriptionLabel.text = movie.overview
    cell.releaseDateLabel.text = movie.release_date
    if let path = movie.poster_path {
      let url = URL(string: path)
      cell.posterImageView.kf.setImage(with: url)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.movies.count - 1 && viewModel.pagesCount >= viewModel.page {
      viewModel.page += 1
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let movie = viewModel.movies[indexPath.row]
    present(MovieDetailsViewController(movie), animated: true)
  }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    viewModel.query = text
  }
}
