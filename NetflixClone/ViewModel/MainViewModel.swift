//
//  ViewModel.swift
//  NetflixClone
//
//  Created by bloom on 7/31/24.
//

import Foundation
import RxSwift
//MARK: 비즈니스 로직을 작성하는

class MainViewModel {
  private let API_KEY = "645e86fb7592fb03db60c09f1419e536"
  private let disposeBag = DisposeBag()
  private let BASE_URL = "https://api.themoviedb.org/3/"
  
  let popularMovieSubject = BehaviorSubject(value: [Movie]())
  let topRatedMovieSubject = BehaviorSubject(value: [Movie]())
  let upcomingMovieSubject = BehaviorSubject(value: [Movie]())
  init(){
    fetchPopularMovie()
    fetchTopRatedMovie()
    fetchUpcomingMovie()
  }
  
  
  
  
  func fetchPopularMovie(){
    guard let url = URL(string: "\(BASE_URL)movie/popular?api_key=\(API_KEY)")
    else{ popularMovieSubject.onError(NetworkError.invalidUrl) ; return }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse ) in
        self?.popularMovieSubject.onNext(movieResponse.results) }
                 ,onFailure: { [weak self] error in
        self?.popularMovieSubject.onError(error)
      }).disposed(by: disposeBag)
    
  }
  
  func fetchTopRatedMovie(){
    guard let url = URL(string: "\(BASE_URL)movie/top_rated?api_key=\(API_KEY)")
    else{ topRatedMovieSubject.onError(NetworkError.invalidUrl) ; return }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse) in
        self?.topRatedMovieSubject.onNext(movieResponse.results)}, onFailure: { [weak self] error in
          self?.topRatedMovieSubject.onError(error)
        }).disposed(by: disposeBag)
    
  }
  
  func fetchUpcomingMovie(){
    guard let url = URL(string: "\(BASE_URL)movie/upcoming?api_key=\(API_KEY)")
    else{ upcomingMovieSubject.onError(NetworkError.invalidUrl) ; return}
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse) in
        self?.upcomingMovieSubject.onNext(movieResponse.results)
      }, onFailure: { [weak self] error in
        self?.upcomingMovieSubject.onError(error)
      }
      ).disposed(by: disposeBag)
      
    
  }
}
