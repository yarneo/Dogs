enum AuthResult<U> {
  case success(result: U)
  case failure(error: AuthError)
}

enum AuthError {
  case LoginFailed(String)
}

protocol LoginAuthProtocol {
  func authorize(request: Login.UserLogin.Request, completion: @escaping (AuthResult<AuthUser>) -> Void)
}

class LoginWorker
{
  let authService: LoginAuthProtocol
  
  init(authService: LoginAuthProtocol) {
    self.authService = authService
  }
  
  func auth(request: Login.UserLogin.Request, completion: @escaping (AuthResult<AuthUser>) -> Void) {
    self.authService.authorize(request: request, completion: completion)
  }
}
