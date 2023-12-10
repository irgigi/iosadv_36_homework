//
//  FeedViewController.swift
//  Navigation


import UIKit


struct Post {
    var title: String
}


class FeedViewController: UIViewController {
    
    var post = Post(title: "Мой пост")

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemCyan
            
        let button = UIButton(type: .system)
        button.setTitle(post.title, for: .normal)
        button.addTarget(self, action: #selector(goToPosrtViewController), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
            
        view.addSubview(button)
    }
        
    @objc func goToPosrtViewController() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
        
        
}
