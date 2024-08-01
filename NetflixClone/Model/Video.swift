//
//  Video.swift
//  NetflixClone
//
//  Created by bloom on 7/30/24.
//

import Foundation


struct VideoResponse: Codable {
/// results라는 객체 안에 여러가지 의 데이터 배열이 있음 ( 즉 영상이 1개가 아니란 의미 )
  let results: [Video]
}

struct Video: Codable {
  
  let type: String?
  let key: String?
  let site: String
}
