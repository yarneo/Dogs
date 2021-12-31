import UIKit

@objc protocol HomeRoutingLogic
{
  func routeToLogin()
}

protocol HomeDataPassing
{
  var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
  weak var viewController: HomeViewController?
  var dataStore: HomeDataStore?
  
  func routeToLogin() {
    guard let viewController = viewController else { return }
    let loginVC = LoginViewController(nibName: nil, bundle: nil)
    var loginDS = loginVC.router!.dataStore!
    passDataToLogin(source: dataStore!, destination: &loginDS)
    navigateToLogin(source: viewController, destination: loginVC)
  }
  
  // MARK: Navigation
  
  func navigateToLogin(source: HomeViewController, destination: LoginViewController) {
    source.navigationController?.setViewControllers([destination], animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToLogin(source: HomeDataStore, destination: inout LoginDataStore)
  {
    destination.loginAuthProvider = source.dogFetchProvider!
  }
}
