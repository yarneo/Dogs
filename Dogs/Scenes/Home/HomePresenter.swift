import UIKit

protocol HomePresentationLogic
{
  func presentFetchedDogs(response: Home.FetchDogs.Response)
}

class HomePresenter: HomePresentationLogic
{
  weak var viewController: HomeDisplayLogic?
    
  func presentFetchedDogs(response: Home.FetchDogs.Response)
  {
    guard let unparsedDogs = response.dogs else { return }
    let dogs: [Dog] = unparsedDogs.map {
      let imageURL = $0.imageURL
      var split = imageURL.split(separator: Character("/"))
      split.removeLast()
      let breed = split.last!
      let imageItem = Item(image: ImageCache.publicCache.placeholderImage, url: URL(string: imageURL)!)
      return Dog(imageItem: imageItem, breed: String(breed))
    }
    let viewModel = Home.FetchDogs.ViewModel(dogs: dogs)
    viewController?.displayFetchedDogs(viewModel: viewModel)
  }
}
