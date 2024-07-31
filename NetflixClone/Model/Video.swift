//
//  Video.swift
//  NetflixClone
//
//  Created by bloom on 7/30/24.
//

import Foundation


struct VideoResponse: Codable {
  let results: [Video]
}

struct Video: Codable {
  let type: String?
  let key: String?
  let site: String
}
