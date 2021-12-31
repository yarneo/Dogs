protocol LoginPresentationLogic
{
  func presentError(response: Login.UserLogin.Response)
  func presentSuccess(response: Login.UserLogin.Response)
}

class LoginPresenter: LoginPresentationLogic
{
  weak var viewController: LoginDisplayLogic?
  
  func presentSuccess(response: Login.UserLogin.Response) {
    let viewModel = Login.UserLogin.ViewModel(email: response.user?.email)
    viewController?.displayLoggedIn(viewModel: viewModel)
  }

  func presentError(response: Login.UserLogin.Response) {
    var errorString: String? = nil
    switch (response.validationError) {
    case .emailError(let err):
      errorString = "Email error: \(err)"
    case .passwordError(let err):
      errorString = "Password error: \(err)"
    case .none: break
    }
    switch (response.authError) {
    case .LoginFailed(let err):
      errorString = "Auth error: \(err)"
    case .none: break
    }
    let viewModel = Login.UserLogin.ViewModel(error: errorString)
    viewController?.displayError(viewModel: viewModel)
  }
}
