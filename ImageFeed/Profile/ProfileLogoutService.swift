//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 18.05.2025.
//

import Foundation
import WebKit


final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let imageListService = ImageListService.shared
    private let oauthTokenStorage = Oauth2TokenStorage.shared
    
    private init() {}
    
    func logout() {
        cleanCookies()
        oauthTokenStorage.token = nil
        profileImageService.logout()
        profileService.logout()
        imageListService.logout()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore
            .default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore
                        .default()
                        .removeData(
                            ofTypes: record.dataTypes,
                            for: [record],
                            completionHandler: {})
                }
            }
        
    }
}
