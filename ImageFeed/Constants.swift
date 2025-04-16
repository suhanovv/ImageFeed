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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let oauthTokenURL = "https://unsplash.com/oauth/token"
}
