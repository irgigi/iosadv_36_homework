//
//  LocalAuthorizationService.swift
//  Navigation


import Foundation
import LocalAuthentication

enum BiometryType {
    case none
    case touchID
    case faseID
}

class LocalAuthorizationService {
    
    static let shared = LocalAuthorizationService()
    private let context: LAContext
    
    private init() {
        self.context = LAContext()
    }
    
    var avaliableBiometry: BiometryType {
        return biometryType()
    }
    
    private func biometryType() -> BiometryType {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .faceID:
                    return .faseID
                case .none:
                    return .none
                case .touchID:
                    return .touchID
                default:
                    return .none
                }
            } else {
                return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
            }
        } else {
            return .none
        }
    }
    /*
     // код с занятия
     
    func checkFace() async throws -> Bool {
        return try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "localizedReason")
    }
    */
    private func canUseBiometrics() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    private func authenticateWITHbiometrics(completion: @escaping (Bool, Error?) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "authorized") { success, error in
            completion(success, error)
            
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) {
        guard canUseBiometrics() else {
            let error = NSError(domain: "BiometryErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Устройство не поддерживает биометрию"])
            authorizationFinished(false, error)
            return
        }
        
        authenticateWITHbiometrics { success, error in
            authorizationFinished(success, error)
        }

    }
}
