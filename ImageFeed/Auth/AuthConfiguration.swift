//
//  Constants.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 10.04.2025.
//

import Foundation

enum Constants {
    static let accessKey = "6L3EEiGZgn88IU6EQxL8heEeV19mO-X8Jaizo2uZfC0"
    static let secretKey = "YK75-TfW51Xi1vfI4C7qdSfN-nW1dE7ketuemmC2NGI"
    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let oauthTokenURL = "https://unsplash.com/oauth/token"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectUri,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            authURLString: Constants.unsplashAuthorizeURLString
        )
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
