//
//  Checker.swift
//  Navigation


import UIKit

class Checker: LoginViewControllerDelegate {

    
    
    static let shared = Checker()
    
    private let loginUser = "felix04"
    private let passwordUser = "1507"
    
    private init() {}
    
    
    
    func check(_ login: String?, _ password: String?) -> Bool {
        return login == loginUser && password == passwordUser
    }
    
    func check(_ login: String?, _ password: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            
            if login == self.loginUser && password == self.passwordUser {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
}
