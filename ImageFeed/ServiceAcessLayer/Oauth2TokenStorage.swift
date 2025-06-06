//
//  Oauth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 18.05.2025.
//

import Foundation
import SwiftKeychainWrapper

protocol Oauth2TokenStorageProtocol: AnyObject {
    var token: String? { get set }
}

final class Oauth2TokenStorage: Oauth2TokenStorageProtocol {
    static let shared = Oauth2TokenStorage()
    private let keyName = "oauthToken"
    
    private init() {}
    
    var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: keyName) else {
                Logger.info("No OAuth2 token found in keychain")
                return nil
            }
            return token
        }
        set {
            if let newValue {
                KeychainWrapper.standard
                    .set(newValue, forKey: keyName)
            } else {
                KeychainWrapper.standard.removeObject(forKey: keyName)
            }
        }
    }
}
