enum Login
{
  // MARK: Use cases
  
  enum UserLogin
  {
    struct Request
    {
      var email: String
      var password: String
    }
    struct Response
    {
      var validationError: ValidateFieldsError?
      var authError: AuthError?
      var user: AuthUser?
    }
    struct ViewModel
    {
      var error: String?
      var email: String?
    }
  }
}

struct AuthUser {
  var email: String
  var password: String
}
