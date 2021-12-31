//
//  NetworkLayer.swift
//  Dogs
//
//  Created by Yarden Eitan on 12/30/21.
//

import Foundation

class NetworkLayer {
  class func request<T: Codable>(urlParts: URLParts, completion: @escaping (Result<T, Error>) -> ()) {
    var components = URLComponents()
    components.scheme = urlParts.scheme
    components.host = urlParts.host
    components.path = urlParts.path
    components.queryItems = urlParts.parameters
    guard let url = components.url else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = urlParts.method
    
    let session = URLSession(configuration: .default)
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard response != nil, let data = data else {
        completion(.failure(RequestError.requestError))
        return
      }
      let responseObject = try! JSONDecoder().decode(T.self, from: data)
      DispatchQueue.main.async {
        completion(.success(responseObject))
      }
    }
    dataTask.resume()
  }
}
