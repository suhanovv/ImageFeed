//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 13.04.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    var token: String? {
        set {
            storage.set(newValue, forKey: "token")
        }
        get {
            return storage.string(forKey: "token")
        }
    }
}
