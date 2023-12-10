//
//  Profile.swift
//  Navigation


import Foundation

struct Profile {
    
    let img: String
    
}

extension Profile {
    static func make() -> [Profile] {
        (1...21).compactMap{ Profile(img: "felix\($0)") }
    }
    
}
