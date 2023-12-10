//
//  LoginInspector.swift
//  Navigation

import UIKit

struct LoginInspector: LoginViewControllerDelegate {
    func check(_ login: String?, _ password: String?) -> Bool {
        let checker = Checker.shared
        return checker.check(login, password)
    }
    
    
}
