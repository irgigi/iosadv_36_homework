//
//  FeedViewController.swift
//  Navigation


import UIKit


struct Post {
    var title: String
}


class FeedViewController: UIViewController {
    
    var post = Post(title: NSLocalizedString("Мой пост", comment: "-"))
    public var pushViewControllerWasCalled = false
    var localNotificationsService = LocalNotificationsService()
    let localAuthorisationService = LocalAuthorizationService.shared
    var isAuthorized = false
    var isDenieded = false
    
    lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle(NSLocalizedString("Would you like to receive notification?", comment: "-"), for: .normal)
        button.addTarget(self, action: #selector(goToNotification), for: .touchUpInside)
        return button
       }()
    
    lazy var txtButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(post.title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToPosrtViewController), for: .touchUpInside)
        return button
    }()
    
    let authView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        view.backgroundColor = .white
        view.layer.zPosition = 1.0
        view.alpha = 1.0
        return view
    }()
    
    
    lazy var biometryButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray

        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(authenticateWithBiometry), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if traitCollection.userInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .dark
            view.backgroundColor = .backgroundColorView
            txtButton.setTitleColor(.white, for: .normal)
            notificationButton.setTitleColor(.white, for: .normal)
        } else {
            overrideUserInterfaceStyle = .light
            view.backgroundColor = .backgroundColorView
            txtButton.setTitleColor(.darkGray, for: .normal)
            notificationButton.setTitleColor(.darkGray, for: .normal)
        }
        


        
        view.addSubview(authView)
        view.addSubview(txtButton)
        view.addSubview(notificationButton)
        authView.addSubview(biometryButton)
        setup()

        checkNotificationPermission()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authView.isHidden == false {
            
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 50)
            switch localAuthorisationService.avaliableBiometry {
            case .none:
                let alertController = UIAlertController(title: "Ошибка", message: "Ваше устройство не поддерживает биометрию или не настроено", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true)
            case .touchID:
                let image = UIImage(systemName: "touchid")
                let imageWithConfiguration = image?.withConfiguration(largeConfig)
                biometryButton.setImage(imageWithConfiguration, for: .normal)
                
            case .faseID:
                let image = UIImage(systemName: "faceid")
                let imageWithConfiguration = image?.withConfiguration(largeConfig)
                biometryButton.setImage(imageWithConfiguration, for: .normal)
            }
            /*
             // с лекции
            Task {
                do {
                    let result = try await LocalAuthorizationService.shared.checkFace()
                    if result {
                        authView.isHidden = true
                    }
                } catch {
                    print (error)
                }
            }
             */
        }

    }
    
    @objc func authenticateWithBiometry() {
        localAuthorisationService.authorizeIfPossible { [weak self] success, error in
            if success {
                print("Успешная авторизация")
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.authView.alpha = 0.0
                    }) { _ in
                        self?.authView.isHidden = true
                        self?.biometryButton.isHidden = true
                    }
                }
            } else {
                print("Неуспешная авторизация")
                if let error = error {
                    print (error.localizedDescription)
                }
            }
        }
    }

        
    @objc func goToPosrtViewController() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
        pushViewControllerWasCalled = true
    }
    
    @objc func goToNotification() {

        
        if isAuthorized {
            return
        } else {
            if isDenieded {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)

                }
            } else {
                Task {
                    do {
                        try await localNotificationsService.request()
                    } catch {
                        print("ошибка при запросе разрешения на уведомления")
                    }
                }
            }

        }
        checkNotificationPermission()
        
    }
    
    private func checkNotificationPermission() {
        Task {
            isAuthorized = await localNotificationsService.authorizationEnabled()
            isDenieded = await localNotificationsService.authorizationDenied()
        }
        
        if isAuthorized {
            notificationButton.isHidden = true

        } else {
            if isDenieded {
                notificationButton.isHidden = true
                
            } else {
                notificationButton.setTitle(NSLocalizedString("Would you like to receive notification?", comment: "-"), for: .normal)
                notificationButton.isHidden = false
                
            }
        }
    }
    
    func setup() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            notificationButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            notificationButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 300),
            notificationButton.heightAnchor.constraint(equalToConstant: 100),
            
            txtButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            txtButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //txtButton.widthAnchor.constraint(equalToConstant: 100),
            //txtButton.heightAnchor.constraint(equalToConstant: 50)
            
            authView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authView.topAnchor.constraint(equalTo: view.topAnchor),
            authView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            biometryButton.centerXAnchor.constraint(equalTo: authView.centerXAnchor),
            biometryButton.centerYAnchor.constraint(equalTo: authView.centerYAnchor, constant: -200),
            biometryButton.widthAnchor.constraint(equalToConstant: 400),
            biometryButton.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
        
        
}
