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
            PostModel(author: "Alex",
                      description: NSLocalizedString("Me in 2 mounth", comment: "-"),
                      image: "felix1",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "Ben",
                      description: NSLocalizedString("Me in 12 years old", comment: "-"),
                      image: "felix2",
                      likes: 105,
                      views: 1008),
            
            PostModel(author: "John",
                      description: NSLocalizedString("Me and my favorite food", comment: "-"),
                      image: "felix3",
                      likes: 86,
                      views: 156),
            
            PostModel(author: "Alex",
                      description: NSLocalizedString("My rest on the computer desk", comment: "-"),
                      image: "felix4",
                      likes: 94,
                      views: 589),
            
            PostModel(author: "Ben",
                      description: NSLocalizedString("My paws", comment: "-"),
                      image: "felix5",
                      likes: 2,
                      views: 3),
            
            PostModel(author: "Kass",
                      description: NSLocalizedString("My love", comment: "-"),
                      image: "felix6",
                      likes: 100,
                      views: 452),
            
            PostModel(author: "Den",
                      description: NSLocalizedString("My love", comment: "-"),
                      image: "felix7",
                      likes: 76,
                      views: 856),
            
        ]
    }
}


