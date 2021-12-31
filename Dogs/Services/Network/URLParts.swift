//
//  URLParts.swift
//  Dogs
//
//  Created by Yarden Eitan on 12/30/21.
//

import Foundation

enum URLParts {
  case fetchDogs

  var scheme: String {
    switch self {
    case .fetchDogs:
      return "https"
    }
  }
  var host: String {
    switch self {
    case .fetchDogs:
      return "dog.ceo"
    }
  }
  var path: String {
    switch self {
    case .fetchDogs:
      return "/api/breeds/image/random"
    }
  }
  var parameters: [URLQueryItem] {
    switch self {
    case .fetchDogs:
      return []
    }
  }
  var method: String {
    switch self {
    case .fetchDogs:
      return "GET"
    }
  }
}
