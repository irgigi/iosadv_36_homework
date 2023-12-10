//
//  PostViewController.swift
//  Navigation


import UIKit

class PostViewController: UIViewController {
    
    var navBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navBarButton = UIBarButtonItem(
            title: "Инфо",
            style: .plain,
            target: self,
            action: #selector(buttonPressed)
            )
        navigationItem.rightBarButtonItem = navBarButton
        
        let feedController = FeedViewController()
        let myTitle = feedController.post.title
        view.backgroundColor = .systemMint
        title = myTitle

    }
    
    @objc func buttonPressed() {
        
        let infoController = InfoViewController()
        infoController.modalTransitionStyle = .coverVertical
        infoController.modalPresentationStyle = .pageSheet
        present (infoController, animated: true, completion: nil)
        
    }
    
    
}
