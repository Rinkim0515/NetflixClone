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
  static let API_KEY = "645e86fb7592fb03db60c09f1419e536"
  private let disposeBag = DisposeBag()
  
  /// url 관리시에 도메인과 버전 패스 등을 나눈다음 합친것을 baseurl로 쓰는방식
  static let BASE_URL = "https://api.themoviedb.org/3" /// 패스도 관리할필요가 있음 링크 는 일괄적으로 처리할수 있도록 룰을 정하는 게 좋겠다. 베이스 URL 과 버전을 나눠서  합친게 baseurl 로 -> 추후의 관리 를 위함  // 문제가 발생한 부분에서 더 쪼개서 찾아보는 // 오류 가능성의 부분 // 흐름의 역순으로 다시 돌아가는것 //
  
  let popularMovieSubject = BehaviorSubject(value: [Movie]())
  let topRatedMovieSubject = BehaviorSubject(value: [Movie]())
  let upcomingMovieSubject = BehaviorSubject(value: [Movie]())
  init(){
    fetchPopularMovie()
    fetchTopRatedMovie()
    fetchUpcomingMovie()
  }
  
  
  
  
  func fetchPopularMovie(){
    guard let url = URL(string: "\(MainViewModel.BASE_URL)/movie/popular?api_key=\(MainViewModel.API_KEY)")
    else{ popularMovieSubject.onError(NetworkError.invalidUrl) ; return }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse ) in
        self?.popularMovieSubject.onNext(movieResponse.results) }
                 ,onFailure: { [weak self] error in
        self?.popularMovieSubject.onError(error)
      }).disposed(by: disposeBag)
    
  }
  
  func fetchTopRatedMovie(){
    guard let url = URL(string: "\(MainViewModel.BASE_URL)/movie/top_rated?api_key=\(MainViewModel.API_KEY)")
    else{ topRatedMovieSubject.onError(NetworkError.invalidUrl) ; return }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse) in
        self?.topRatedMovieSubject.onNext(movieResponse.results)}, onFailure: { [weak self] error in
          self?.topRatedMovieSubject.onError(error)
        }).disposed(by: disposeBag)
    
  }
  
  func fetchUpcomingMovie(){
    guard let url = URL(string: "\(MainViewModel.BASE_URL)/movie/upcoming?api_key=\(MainViewModel.API_KEY)")
    else{ upcomingMovieSubject.onError(NetworkError.invalidUrl) ; return}
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse) in
        self?.upcomingMovieSubject.onNext(movieResponse.results)
      }, onFailure: { [weak self] error in
        self?.upcomingMovieSubject.onError(error)
      }
      ).disposed(by: disposeBag)
      
    
  }
  
  ///동영상의 키값을 return 하는 method
    func fetchTrailerKey(movie: Movie) -> Single<String> {
      guard let movieId = movie.id else { return Single.error (NetworkError.dataFetchFail) }
      
      let urlString =
      "\(MainViewModel.BASE_URL)/movie/\(movieId)/videos?api_key=\(MainViewModel.API_KEY)"
      /// 슬래쉬 하나빠진 문제
      guard let url = URL(string: urlString) else { return Single.error(NetworkError.invalidUrl)}
     
      return NetworkManager.shared.fetch(url: url)
        .flatMap{ (videoResponse: VideoResponse) -> Single<String> in
          if let trailer = videoResponse.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube"}) {
            guard let key = trailer.key else { return Single.error(NetworkError.dataFetchFail)}
            return Single.just(key)
          } else {
            print(#function)
            return Single.error(NetworkError.dataFetchFail)
          } }
    }
}
