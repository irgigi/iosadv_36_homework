//
//  UserServiceProtocol.swift
//  Navigation

import Foundation

protocol UserServiceProtocol {
    
    func getUser(_ login: String) -> User?
    
}
