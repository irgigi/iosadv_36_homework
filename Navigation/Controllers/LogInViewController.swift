//
//  LogInViewController.swift
//  Navigation


import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var loginDelegate: LoginViewControllerDelegate?

    var brute = BruteForceClass()
    
    private var likeService = LikeService()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.blue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var scrollFieldView: UIScrollView = {
        let scrollFieldView = UIScrollView()
        scrollFieldView.showsVerticalScrollIndicator = true
        scrollFieldView.showsHorizontalScrollIndicator = false
        scrollFieldView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return scrollFieldView
    }()
    
    lazy var vkView: UIImageView = {
        
        let image = UIImageView (
            frame: CGRect()
        )
        image.image = UIImage(named: "VK")
        
        return image
    }()
    
    
    lazy var loginField: UITextField = {
        let text = UITextField()
        
        text.backgroundColor = .systemGray6
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //text.placeholder = "login"
        text.text = "felix04"
        text.textColor = UIColor.black
        text.tintColor = UIColor(named: "MyColor")
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.autocapitalizationType = .none
        text.keyboardType = .default
        text.returnKeyType = .done
        text.clearButtonMode = .whileEditing
        text.contentVerticalAlignment = .center
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.tag = 0
        
        
        return text
    }()
    
    lazy var passwordField: UITextField = {
        let text = UITextField()
        
        text.backgroundColor = .systemGray6
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //text.placeholder = "password"
        text.text = "1507"
        text.textColor = UIColor.black
        text.tintColor = UIColor(named: "MyColor")
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.autocapitalizationType = .none
        text.keyboardType = .default
        text.returnKeyType = .done
        text.clearButtonMode = .whileEditing
        text.contentVerticalAlignment = .center
        text.isSecureTextEntry = true
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.tag = 1
        
        return text
    }()
    
    let spaceView = UIView()
    
    lazy var logInButton: UIButton = {
        let button = UIButton()
        let bluePixelImage = UIImage(named: "blue_pixel")
        button.setBackgroundImage(bluePixelImage, for: .normal)
        button.backgroundImage(for: .normal)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(buttonToProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var pickUpPasswordButton: UIButton = {
        let button = UIButton()
        let bluePixelImage = UIImage(named: "blue_pixel")
        button.setBackgroundImage(bluePixelImage, for: .normal)
        button.backgroundImage(for: .normal)
        button.setTitle("Подобрать пароль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(findPassword), for: .touchUpInside)
        return button
    }()
    
    lazy var stackViewForFields: UIStackView = {
        let stackViewForFields = UIStackView()
        stackViewForFields.axis = .vertical
        stackViewForFields.alignment = .fill
        stackViewForFields.distribution = .fillEqually
        stackViewForFields.spacing = 0.5
        return stackViewForFields
    }()
    
    func generatePassword() -> String {
        let char = String().printable
        var generatedPassword = ""
        for _ in 0...2 {
            let randomIndex = Int(arc4random_uniform(UInt32(char.count)))
            let randomChar = char[char.index(char.startIndex, offsetBy: randomIndex)]
            generatedPassword.append(randomChar)
        }
        return generatedPassword
    }
    
    @objc func findPassword() {
        
        activityIndicator.startAnimating()
        
        let generatedPassword = generatePassword()
        print("сгенерированный пароль: \(generatedPassword)")
        
        DispatchQueue.global().async { [self] in
            
            DispatchQueue.main.async { [self] in
                pickUpPasswordButton.isHidden = true
            }
            
            let password = self.brute.bruteForce(passwordToUnlock: generatedPassword)
            
            DispatchQueue.main.async { [self] in
                
                self.activityIndicator.stopAnimating()
                passwordField.text = password
                passwordField.isSecureTextEntry = false
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    
        view.addSubview(vkView)
        view.addSubview(scrollFieldView)
        view.addSubview(activityIndicator)
        scrollFieldView.addSubview(stackViewForFields)
        scrollFieldView.addSubview(logInButton)
        scrollFieldView.addSubview(pickUpPasswordButton)
        stackViewForFields.addArrangedSubview(loginField)
        stackViewForFields.addArrangedSubview(passwordField)
        stackViewForFields.addArrangedSubview(spaceView)
        
        self.setupElements()
        
        self.loginField.delegate = self
        self.passwordField.delegate = self
        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    /*
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        return loginField.resignFirstResponder()
    }
    */
    override func touchesBegan(_ textField: Set<UITouch>, with event: UIEvent?) {
        self.scrollFieldView.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
 
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
        
    }
    
    
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func getLogin() -> String {
        if let login = loginField.text {
            return login
        }
        return "no login"
    }
    
    @objc private func buttonToProfile() {
       
        let profileViewController = ProfileViewController(likeService: likeService)
        let logInspector = LoginInspector()

        guard let login = loginField.text, let password = passwordField.text else {
            
            return
            
        }
        
/*
#if DEBUG
              let test = TestUserService()
              if test.userTest?.login == login {
                  ProfileTableHeaderView.userProfile = test.userTest
                  navigationController?.pushViewController(profileViewController, animated: true)
              }
#else
              let current = CurrentUserService()
              if current.currentUser?.login == login {
                  
                  ProfileTableHeaderView.userProfile = current.currentUser
                  navigationController?.pushViewController(profileViewController, animated: true)
              } else {
                  print("ERROR")
              }
#endif
 */
        let loginResult = logInspector.check(login, password)
        
        if loginResult {
            let current = CurrentUserService()
            ProfileTableHeaderView.userProfile = current.currentUser
            navigationController?.pushViewController(profileViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Unknown login or password", message: "Please, enter correct user login/password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
            
          

      }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollFieldView.contentInset.bottom += keyboardHeight ?? 0.0
        
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollFieldView.contentInset.bottom = 0.0
    }
 
    
    private func setupElements() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        scrollFieldView.translatesAutoresizingMaskIntoConstraints = false
        vkView.translatesAutoresizingMaskIntoConstraints = false
        loginField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        stackViewForFields.translatesAutoresizingMaskIntoConstraints = false
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        pickUpPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            vkView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 120),
            vkView.widthAnchor.constraint(equalToConstant: 100),
            vkView.heightAnchor.constraint(equalToConstant: 100),
            vkView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            vkView.bottomAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: -20),
            
            scrollFieldView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            scrollFieldView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            scrollFieldView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            scrollFieldView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            scrollFieldView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
      
            stackViewForFields.topAnchor.constraint(equalTo: scrollFieldView.topAnchor),
            stackViewForFields.leadingAnchor.constraint(equalTo: scrollFieldView.leadingAnchor),
            stackViewForFields.trailingAnchor.constraint(equalTo: scrollFieldView.trailingAnchor),
            stackViewForFields.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -16),
            stackViewForFields.heightAnchor.constraint(equalToConstant: 100),
            stackViewForFields.centerXAnchor.constraint(equalTo: scrollFieldView.centerXAnchor),
        
            loginField.topAnchor.constraint(equalTo: stackViewForFields.topAnchor),
            loginField.leadingAnchor.constraint(equalTo: stackViewForFields.leadingAnchor),
            loginField.trailingAnchor.constraint(equalTo: stackViewForFields.trailingAnchor),
           // loginField.heightAnchor.constraint(equalToConstant: 50),
            loginField.widthAnchor.constraint(equalTo: stackViewForFields.widthAnchor),
            loginField.bottomAnchor.constraint(equalTo: spaceView.topAnchor),
           
            spaceView.heightAnchor.constraint(equalToConstant: 0.5),
            spaceView.leadingAnchor.constraint(equalTo: stackViewForFields.leadingAnchor),
            spaceView.trailingAnchor.constraint(equalTo: stackViewForFields.trailingAnchor),
            spaceView.topAnchor.constraint(equalTo: loginField.bottomAnchor),
            //spaceView.bottomAnchor.constraint(equalTo: passwordField.topAnchor),
            
        
            passwordField.topAnchor.constraint(equalTo: spaceView.bottomAnchor),
            passwordField.leadingAnchor.constraint(equalTo: stackViewForFields.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: stackViewForFields.trailingAnchor),
            passwordField.widthAnchor.constraint(equalTo: stackViewForFields.widthAnchor),
           // passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.bottomAnchor.constraint(equalTo: stackViewForFields.bottomAnchor),
            
            logInButton.topAnchor.constraint(equalTo: stackViewForFields.bottomAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.widthAnchor.constraint(equalTo: scrollFieldView.widthAnchor),
            logInButton.leadingAnchor.constraint(equalTo: scrollFieldView.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: scrollFieldView.trailingAnchor),
            logInButton.bottomAnchor.constraint(equalTo: pickUpPasswordButton.topAnchor, constant: -10),
            
            pickUpPasswordButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor),
            pickUpPasswordButton.leadingAnchor.constraint(equalTo: scrollFieldView.leadingAnchor),
            pickUpPasswordButton.trailingAnchor.constraint(equalTo: scrollFieldView.trailingAnchor),
            pickUpPasswordButton.bottomAnchor.constraint(equalTo: scrollFieldView.bottomAnchor),
            pickUpPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            pickUpPasswordButton.widthAnchor.constraint(equalTo: scrollFieldView.widthAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: vkView.bottomAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: scrollFieldView.topAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 80),
            activityIndicator.heightAnchor.constraint(equalToConstant: 80)

        ])
        
    }
    
    
}

