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
            
        view.addSubview(txtButton)
        view.addSubview(notificationButton)
        setup()

        checkNotificationPermission()
        
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
        ])
    }
        
        
}
