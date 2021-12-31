enum Home
{
  // MARK: Use cases
  
  enum FetchDogs
  {
    struct Request
    {
    }
    struct Response
    {
      var dogs: [DogParsedJSON]?
    }
    struct ViewModel
    {
      var dogs: [Dog]
    }
  }
}
