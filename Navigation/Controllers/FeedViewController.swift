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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.userInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .dark
            view.backgroundColor = .backgroundColorView
        } else {
            overrideUserInterfaceStyle = .light
            view.backgroundColor = .backgroundColorView
        }
        
        let button = UIButton(type: .system)
        if traitCollection.userInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .dark
            button.setTitleColor(.lightGray, for: .normal)
        } else {
            overrideUserInterfaceStyle = .light
            button.setTitleColor(.darkGray, for: .normal)
        }
        
        button.setTitle(post.title, for: .normal)
        button.addTarget(self, action: #selector(goToPosrtViewController), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
            
        view.addSubview(button)
    }
        
    @objc func goToPosrtViewController() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
        pushViewControllerWasCalled = true
    }
        
        
}
