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
  let results: [Movie] // 껍데기 구조체 
  
}

struct Movie: Codable {
  
  let id: Int?
  let title: String?
  let posterPath: String?
  
  enum CodingKeys: String,CodingKey {
    case id, title
    case posterPath = "poster_path"
  }
}
