//
//  MovieDBApiTests.swift
//  MovieDBApiTests
//
//  Created by Max Shashkov on 17.05.2022.
//

import XCTest
import Combine
@testable import MovieDBApi

class MovieDBApiTests: XCTestCase {
  var movieService: MovieService!
  var subscriptions = Set<AnyCancellable>()
  override func setUpWithError() throws {
    try super.setUpWithError()
    movieService = MovieService.shared
  }
  
  override func tearDownWithError() throws {
    movieService = nil
    try super.tearDownWithError()
  }
  
  func testGetWeeklyTrendingMovies() {
    //given
    guard let url = movieService.createURL(for: .weeklyTrendingMovies) else {
      XCTFail("cannot create an URL")
      return
    }
    let promice = expectation(description: "movies received")
    var movies = [Movie]()
    //when
    let moviesPublisher = movieService.getMovies(with: url)
    moviesPublisher.sink { response in
      //then
      movies = response.movies
      promice.fulfill()
    }
    .store(in: &subscriptions)
    wait(for: [promice], timeout: 5)
    XCTAssertGreaterThan(movies.count, 0)
  }
  
  func testGetQueryMovies() {
    //given
    let query = "The lord of the rings"
    guard let url = movieService.createURL(for: .searchMovie, query: query) else {
      XCTFail("cannot create an URL")
      return
    }
    let promice = expectation(description: "movies received")
    var movies = [Movie]()
    //when
    let moviesPublisher = movieService.getMovies(with: url)
    moviesPublisher.sink { response in
      //then
      movies = response.movies
      promice.fulfill()
    }
    .store(in: &subscriptions)
    wait(for: [promice], timeout: 5)
    XCTAssertGreaterThan(movies.count, 0)
  }
}
