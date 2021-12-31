import UIKit

@objc protocol LoginRoutingLogic
{
  func routeToHome()
}

protocol LoginDataPassing
{
  var dataStore: LoginDataStore? { get }
}


class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing
{
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?
  
  // MARK: Routing
  
  func routeToHome() {
    guard let viewController = viewController else { return }
    let homeVC = HomeViewController(nibName: nil, bundle: nil)
    var homeDS = homeVC.router!.dataStore!
    passDataToHome(source: dataStore!, destination: &homeDS)
    navigateToHome(source: viewController, destination: homeVC)
  }

  // MARK: Navigation
  
  func navigateToHome(source: LoginViewController, destination: HomeViewController) {
    source.navigationController?.setViewControllers([destination], animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToHome(source: LoginDataStore, destination: inout HomeDataStore)
  {
    destination.dogFetchProvider = source.loginAuthProvider
  }
}
