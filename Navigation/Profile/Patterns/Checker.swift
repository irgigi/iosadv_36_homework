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
    
}
