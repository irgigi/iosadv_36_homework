//
//  SceneDelegate.swift
//  Navigation


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static let language = NSLocalizedString("language", comment: "-")
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //print("---", language)
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return } //добавили scene вместо _
        let window = UIWindow(windowScene: scene) //экземпляр класса window
       
        let tabBarController = UITabBarController()
        
        let firstNavController = UINavigationController(rootViewController: FeedViewController()) //

        let secondNavController = UINavigationController(rootViewController: LogInViewController()) // было ProfileViewController()
        
        let postNavController = UINavigationController(rootViewController: PostViewController())
        
        let likeController = UINavigationController(rootViewController: LikePostController())
        
        
       // let infoNavController = UINavigationController(rootViewController: InfoViewController())
        
        firstNavController.tabBarItem = UITabBarItem(title: NSLocalizedString("Лента пользователя", comment: "-"), image: UIImage(systemName: "heart") , tag: 0)
        
        secondNavController.tabBarItem = UITabBarItem(title: NSLocalizedString("Профиль", comment: "-"), image: UIImage(systemName: "house"), tag: 2)
        
        likeController.tabBarItem = UITabBarItem(title: NSLocalizedString("Избранное", comment: "-"), image: UIImage(systemName: "hand.thumbsup"), tag: 1)
        
        postNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        tabBarController.viewControllers = [firstNavController, likeController, secondNavController]
        
        //new 1
        let loginViewController = LogInViewController()
        var loginInspector = LoginInspector()
        
        loginViewController.loginDelegate = loginInspector
        
        //new 2
        let loginFactory: LoginFactory = MyLogInFactory()
        loginInspector = loginFactory.makeLoginInspector()
        
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        //new
        //CoreDataService.shared.saveContext()

    }


}

