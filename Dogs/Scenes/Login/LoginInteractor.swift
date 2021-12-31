protocol LoginBusinessLogic
{
  func attemptLogin(request: Login.UserLogin.Request)
}

protocol LoginDataStore {
  var loginAuthProvider: DogsAPI? { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore
{
  var loginAuthProvider: DogsAPI? = NetworkService()
  var presenter: LoginPresentationLogic?
  var loginWorker: LoginWorker?
  var validationWorker: ValidationWorker?
  
  
  func attemptLogin(request: Login.UserLogin.Request)
  {
    validationWorker = ValidationWorker()
    validationWorker?.validateFields(request: request) { result in
      switch(result) {
      case .success:
        self.loginWorker = LoginWorker(authService: self.loginAuthProvider!)
        self.loginWorker?.auth(request: request) { result in
          switch(result) {
          case .success(result: let a):
            let response = Login.UserLogin.Response(user: a)
            self.presenter?.presentSuccess(response: response)
          case .failure(error: let error):
            let response = Login.UserLogin.Response(authError: error)
            self.presenter?.presentError(response: response)
          }
        }
      case .failure(error: let error):
        let response = Login.UserLogin.Response(validationError: error)
        self.presenter?.presentError(response: response)
      }
    }
  }

}
