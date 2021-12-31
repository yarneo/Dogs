import UIKit

protocol HomeDisplayLogic: AnyObject
{
  func displayFetchedDogs(viewModel: Home.FetchDogs.ViewModel)
}

class HomeViewController: UITableViewController, HomeDisplayLogic
{
  var interactor: HomeBusinessLogic?
  var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    self.title = "Dogs"
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    fetchDogs()
    showActivityIndicator()
    self.view.backgroundColor = .white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
    navigationController?.navigationBar.topItem?.rightBarButtonItem = logoutButton
  }
  
  var dogs: [Dog]?
  
  func showActivityIndicator() {
      DispatchQueue.main.async {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.hidesWhenStopped = true
        self.tableView.backgroundView = activityView
        activityView.startAnimating()
      }
  }
  
  @objc func logout() {
    router?.routeToLogin()
  }
  
  func fetchDogs()
  {
    let request = Home.FetchDogs.Request()
    interactor?.fetchDogs(request: request)
  }
  
  func displayFetchedDogs(viewModel: Home.FetchDogs.ViewModel) {
    dogs = viewModel.dogs
    if let activityIndicator = self.tableView.backgroundView as? UIActivityIndicatorView {
      activityIndicator.stopAnimating()
    }
    tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dogs?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    guard let dog = dogs?[indexPath.row] else {
      return cell
    }
    var contentConfig = cell.defaultContentConfiguration()
    contentConfig.image = dog.imageItem.image
    contentConfig.imageProperties.maximumSize = CGSize(width: 100, height: 100)
    contentConfig.text = dog.breed
    ImageCache.publicCache.load(url: dog.imageItem.url as NSURL, item: dog.imageItem) { (fetchedItem, image) in
      if let img = image, img != fetchedItem.image {
        self.dogs?.enumerated().forEach {
          if $0.1.imageItem == fetchedItem {
            $0.1.imageItem.image = img
            self.tableView.reloadRows(at: [IndexPath(row: $0.0, section: 0)], with: .automatic)
          }
        }
      }
    }
    cell.contentConfiguration = contentConfig
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
}
