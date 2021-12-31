enum ValidateFieldsResult {
  case success
  case failure(error: ValidateFieldsError)
}

enum ValidateFieldsError: Equatable, Error
{
  case emailError(String)
  case passwordError(String)
}

protocol ValidateFieldsProtocol {
  func validateFields(request: Login.UserLogin.Request, completion: @escaping (ValidateFieldsResult) -> Void)
}

class ValidationWorker: ValidateFieldsProtocol
{
  
  func validateFields(request: Login.UserLogin.Request, completion: @escaping (ValidateFieldsResult) -> Void) {
    if !request.email.contains(Character("@")) {
      completion(.failure(error: .emailError("No @ character in email")))
      return
    }
    if request.password.count < 6 {
      completion(.failure(error: .passwordError("Password is too short, it must be 6 character or longer")))
      return
    }
    completion(.success)
  }
}
