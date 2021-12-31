//
//  Dog.swift
//  Dogs
//
//  Created by Yarden Eitan on 12/30/21.
//

import Foundation
import UIKit

struct Dog {
  var imageItem: Item
  var breed: String
}

struct DogParsedJSON: Codable {
  var imageURL: String
  var status: String
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "message"
    case status
  }
}
