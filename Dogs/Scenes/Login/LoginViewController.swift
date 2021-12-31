import UIKit

protocol LoginDisplayLogic: AnyObject
{
  func displayError(viewModel: Login.UserLogin.ViewModel)
  func displayLoggedIn(viewModel: Login.UserLogin.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic
{
  var interactor: LoginBusinessLogic?
  var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    commonLoginInit()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    commonLoginInit()
  }
  
  // MARK: Setup
  
  private func commonLoginInit() {
    setup()
  }
  
  private func setup()
  {
    let viewController = self
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
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
    super.viewDidLoad()
    configureViews()
  }
    
  var email: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.layer.cornerRadius = 4
    textField.layer.borderColor = UIColor.systemBlue.cgColor
    textField.layer.borderWidth = 0.5
    textField.font = UIFont.systemFont(ofSize: 14)
    textField.tag = 1
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    return textField
  }()

  var password: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.layer.cornerRadius = 4
    textField.layer.borderColor = UIColor.systemBlue.cgColor
    textField.layer.borderWidth = 0.5
    textField.font = UIFont.systemFont(ofSize: 14)
    textField.tag = 2
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    return textField
  }()
  
  var login: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Login", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(doLoginAction), for: .touchUpInside)
    return button
  }()
  
  var emailLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Email"
    label.font = UIFont.systemFont(ofSize: 10)
    return label
  }()
  
  var passwordLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Password"
    label.font = UIFont.systemFont(ofSize: 10)
    return label
  }()
  
  var errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .systemRed
    label.isHidden = true
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  var skipButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Skip", for: .normal)
    button.addTarget(self, action: #selector(doSkipAction), for: .touchUpInside)
    return button
  }()
  
  func configureViews() {
    view.backgroundColor = .systemBackground
    view.addSubview(email)
    view.addSubview(password)
    view.addSubview(login)
    view.addSubview(emailLabel)
    view.addSubview(passwordLabel)
    view.addSubview(errorLabel)
    view.addSubview(skipButton)
    email.delegate = self
    password.delegate = self
    NSLayoutConstraint.activate([
      emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      email.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
      email.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      email.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      email.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
      passwordLabel.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 5),
      passwordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      password.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 2),
      password.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      password.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      password.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
      login.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 5),
      login.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      skipButton.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 5),
      skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      errorLabel.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 10),
      errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
    ])
  }
  
  @objc func doLoginAction() {
    let request = Login.UserLogin.Request(email: email.text ?? "", password: password.text ?? "")
    interactor?.attemptLogin(request: request)
  }
  
  @objc func doSkipAction() {
    router?.routeToHome()
  }
  
  func displayError(viewModel: Login.UserLogin.ViewModel) {
    if let error = viewModel.error {
      errorLabel.text = error
      errorLabel.isHidden = false
    } else {
      errorLabel.isHidden = true
    }
  }
  
  func displayLoggedIn(viewModel: Login.UserLogin.ViewModel) {
    errorLabel.isHidden = false
    router?.routeToHome()
  }
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1

    if let nextResponder = textField.superview?.viewWithTag(nextTag) {
        nextResponder.becomeFirstResponder()
    } else {
        textField.resignFirstResponder()
    }

    return true
  }
}
