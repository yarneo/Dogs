import Foundation

protocol DogsNetworkProtocol {
  func fetchDog(completionHandler: @escaping (Result<DogParsedJSON, Error>) -> Void)
}

class HomeWorker
{
  var dogsStore: DogsNetworkProtocol
  
  init(dogsStore: DogsNetworkProtocol) {
    self.dogsStore = dogsStore
  }

  func fetchDogs(_ completion: @escaping ([DogParsedJSON]?) -> Void) {
    fetchDog(10) { dogs in
      completion(dogs)
    }
  }
  
  func fetchDog(_ dogsLeft: Int, completion: @escaping (_ dogs: [DogParsedJSON]) -> Void) {
    if dogsLeft == 0 { completion([DogParsedJSON]()) }
    dogsStore.fetchDog { (result: Result<DogParsedJSON, Error>) in
      switch result {
      case .success(let dog):
        self.fetchDog(dogsLeft - 1) { dogs in
          var dogs = dogs
          dogs.append(dog)
          completion(dogs)
        }
      case .failure(let error):
        print(error)
        self.fetchDog(0) { dogs in
          completion(dogs)
        }
      }
    }
  }
}
