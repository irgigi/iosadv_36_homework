//
//  User.swift
//  Navigation


import UIKit

class User {
    
    let login: String
    let name: String
    let status: String
    let avatar: UIImage
    
    init(login: String, name: String, status: String, avatar: UIImage) {
        self.login = login
        self.name = name
        self.status = status
        self.avatar = avatar
    }
    
}



