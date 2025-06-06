//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 18.05.2025.
//

import Foundation
import WebKit

// MARK: - Protocols

protocol ProfileLogoutServiceProtocol {
    func logout()
}

// MARK: - ProfileLogoutService

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let imageListService = ImageListService.shared
    private let oauthTokenStorage = Oauth2TokenStorage.shared

    func logout() {
        cleanCookies()
        oauthTokenStorage.token = nil
        profileImageService.logout()
        profileService.logout()
        imageListService.logout()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        
        let dataStore = WKWebsiteDataStore.default()
        let allTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        dataStore.fetchDataRecords(ofTypes: allTypes) { records in
            records.forEach {
                dataStore.removeData(ofTypes: $0.dataTypes, for: [$0], completionHandler: {})
            }
        }
    }
}
