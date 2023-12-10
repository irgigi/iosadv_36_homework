//
//  LoginViewControllerDelegate.swift
//  Navigation

import UIKit

protocol LoginViewControllerDelegate {
    
    func check(_ login: String?, _ password: String?) -> Bool
    
}
