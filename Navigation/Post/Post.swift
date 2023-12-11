//
//  Post.swift
//  Navigation
//

//

import Foundation

struct PostModel {
    let author: String
    let description: String
    let image: String
    let likes: Int16
    let views: Int16
}

extension PostModel {
    static func make() -> [PostModel] {
        [  //NSLocalizedString(, comment: "-")
            PostModel(author: NSLocalizedString("Alex", comment: "-"),
                      description: NSLocalizedString("Me in 2 mounth", comment: "-"),
                      image: "felix1",
                      likes: 50,
                      views: 178),
            
            PostModel(author: NSLocalizedString("Ben", comment: "-"),
                      description: NSLocalizedString("Me in 12 years old", comment: "-"),
                      image: "felix2",
                      likes: 105,
                      views: 1008),
            
            PostModel(author: NSLocalizedString("John", comment: "-"),
                      description: NSLocalizedString("Me and my favorite food", comment: "-"),
                      image: "felix3",
                      likes: 86,
                      views: 1356),
            
            PostModel(author: "Alex",
                      description: NSLocalizedString("My rest on the computer desk", comment: "-"),
                      image: "felix4",
                      likes: 94,
                      views: 589),
            
            PostModel(author: "Ben",
                      description: NSLocalizedString("My paws", comment: "-"),
                      image: "felix5",
                      likes: 67,
                      views: 1678),
            
            PostModel(author: NSLocalizedString("Kass", comment: "-"),
                      description: NSLocalizedString("My love", comment: "-"),
                      image: "felix6",
                      likes: 100,
                      views: 1452),
            
            PostModel(author: NSLocalizedString("Den", comment: "-"),
                      description: NSLocalizedString("My love", comment: "-"),
                      image: "felix7",
                      likes: 76,
                      views: 856),
            
        ]
    }
}


