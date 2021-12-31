protocol HomeBusinessLogic
{
  func fetchDogs(request: Home.FetchDogs.Request)
}

protocol HomeDataStore
{
  var dogs: [DogParsedJSON]? { get }
  var dogFetchProvider: DogsAPI? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
  var dogFetchProvider: DogsAPI?
  var presenter: HomePresentationLogic?
  var worker: HomeWorker?
  var dogs: [DogParsedJSON]?
    
  func fetchDogs(request: Home.FetchDogs.Request)
  {
    worker = HomeWorker(dogsStore: dogFetchProvider!)
    worker?.fetchDogs { (dogs) -> Void in
      let response = Home.FetchDogs.Response(dogs: dogs)
      self.presenter?.presentFetchedDogs(response: response)
    }
  }
}
