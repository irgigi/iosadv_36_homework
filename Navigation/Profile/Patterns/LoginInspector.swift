//
//  LoginInspector.swift
//  Navigation

import UIKit

struct LoginInspector: LoginViewControllerDelegate {
    
    private let checker: LoginViewControllerDelegate //=
    
    init(checker: LoginViewControllerDelegate = Checker.shared) {
        self.checker = checker
    }
    
    func check(_ login: String?, _ password: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        //let checker = Checker.shared
        checker.check(login, password, completion: completion)
    }
    
    
}
