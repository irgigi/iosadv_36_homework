//
//  CurrentUserService.swift
//  Navigation


import UIKit

class CurrentUserService: UserServiceProtocol {
    
    // по идее должна быть БД, не поняла где хранить данные о пользователе
    var currentUser: User? = User(login: "felix15", name: "Cat Felix", status: "hello, world", avatar: (UIImage(named: "Felix") ?? UIImage()))
    
 
    func getUser(_ login: String) -> User? {
        /*
        guard let currentUser = currentUser, currentUser.login == login else {
            return nil
        }
        return currentUser
         */
        // проще:
        
        return currentUser?.login == login ? currentUser: nil
    }
    
}
