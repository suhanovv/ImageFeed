//
//  Profile.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 26.04.2025.
//

import Foundation

struct Profile {
    let username: String
    let firstName: String
    let lastName: String?
    var fullName: String {
        "\(firstName) \(lastName ?? "")"
    }
    var loginName: String {
        "@\(username)"
    }
    let bio: String?
    
    init(from profileResponse: ProfileResponse) {
        username = profileResponse.username
        firstName = profileResponse.firstName
        lastName = profileResponse.lastName
        bio = profileResponse.bio
    }
}
