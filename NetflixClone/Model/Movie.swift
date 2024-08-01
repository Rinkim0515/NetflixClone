//
//  Movie.swift
//  NetflixClone
//
//  Created by bloom on 7/30/24.
//

import Foundation

struct Constants {
  
}

struct MovieResponse: Codable {
///객체이름자체가 results로 오고 배열식으로 옴
  let results: [Movie]
  
}

/// 실제로 받을 데이터들, 이 데이터의 배열이 results안에 들어있음
struct Movie: Codable {
  
  let id: Int?
  let title: String?
  let posterPath: String?
  
  enum CodingKeys: String,CodingKey {
    case id, title
    case posterPath = "poster_path"
  }
}
