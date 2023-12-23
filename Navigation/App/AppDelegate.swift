//
//  AppDelegate.swift
//  Navigation


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //рандомный выбор url
        let randomConfiguration = AppConfiguration.allCases.randomElement()
        
        if let configuration = randomConfiguration {
            //передаем в сервис
            NetworkManager.request(for: configuration)

        }
        
        let localNotificationsService = LocalNotificationsService()
        Task {
            if await localNotificationsService.authorizationEnabled() {
                localNotificationsService.addNotification()
            }
        }
        
        
        
        
        
        // Override point for customization after application launch.
        
        //new
        /*
        
        let loginViewController = LogInViewController()
        let loginInspector = LoginInspector()
        
        loginViewController.loginDelegate = loginInspector
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
        */
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

