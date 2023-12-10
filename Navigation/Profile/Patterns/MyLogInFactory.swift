//
//  MyLogInFactory.swift
//  Navigation


import UIKit

struct MyLogInFactory: LoginFactory {
    
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
    
    
}
