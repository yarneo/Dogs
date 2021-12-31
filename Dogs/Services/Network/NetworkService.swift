//
//  NetworkService.swift
//  Dogs
//
//  Created by Yarden Eitan on 12/23/21.
//

import Foundation

protocol DogsAPI: LoginAuthProtocol, DogsNetworkProtocol {}

class NetworkService: DogsAPI {
  
  init() {
    let keychainItem = [
      kSecValueData: "bar123".data(using: .utf8)!,
      kSecAttrAccount: "foo",
      kSecAttrServer: "gmail.com",
      kSecClass: kSecClassInternetPassword
    ] as CFDictionary

    let status = SecItemAdd(keychainItem, nil)
    if status != 0 && status != -25299 {
      fatalError("Operation finished with status: \(status)")
    }
  }
  
  func authorize(request: Login.UserLogin.Request, completion: @escaping (AuthResult<AuthUser>) -> Void) {
    let query = [
      kSecClass: kSecClassInternetPassword,
      kSecAttrServer: "gmail.com",
      kSecAttrAccount: "foo",
      kSecReturnAttributes: true,
      kSecReturnData: true
    ] as CFDictionary

    var result: AnyObject?
    let status = SecItemCopyMatching(query, &result)
    if status != 0 {
      completion(.failure(error: .LoginFailed("Couldn't retreive password from keychain error: \(status)")))
      return
    }
    let dic = result as! NSDictionary
    let email = "\(dic[kSecAttrAccount] ?? "")@\(dic[kSecAttrServer] ?? "")"
    let password = String(data: dic[kSecValueData] as! Data, encoding: .utf8)!
    if request.email == email && request.password == password {
      completion(.success(result: AuthUser(email: email, password: password)))
    } else {
      completion(.failure(error: .LoginFailed("Wrong email or password")))
    }
  }
}

extension NetworkService {
  func fetchDog(completionHandler: @escaping (Result<DogParsedJSON, Error>) -> Void) {
    NetworkLayer.request(urlParts: URLParts.fetchDogs) { (result: Result<DogParsedJSON, Error>) in
      completionHandler(result)
    }
  }
}

enum RequestError: Error {
  case requestError
}
