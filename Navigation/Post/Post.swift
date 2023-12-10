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
        [
            PostModel(author: "Alex",
                      description: "Me in 2 mounth",
                      image: "felix1",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "Ben",
                      description: "Me in 12 years old",
                      image: "felix2",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "John",
                      description: "Me and my favorite food",
                      image: "felix3",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "Alex",
                      description: "My rest on the computer desk",
                      image: "felix4",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "Ben",
                      description: "My paws",
                      image: "felix5",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "Kass",
                      description: "My love",
                      image: "felix6",
                      likes: 1,
                      views: 1),
            
            PostModel(author: "Den",
                      description: "My love",
                      image: "felix7",
                      likes: 1,
                      views: 1),
            
        ]
    }
}


