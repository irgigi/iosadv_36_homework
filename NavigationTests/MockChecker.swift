//
//  MocChecker.swift
//  NavigationTests


import Foundation
import XCTest
@testable import Navigation

class MockChecker: LoginViewControllerDelegate {
    
    var fakeResult: Result<Bool, Error>!
    
    func check(_ login: String?, _ password: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(fakeResult)
    }
    
}
