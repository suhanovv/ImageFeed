//
//  Profile.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 26.04.2025.
//

import Foundation

struct Profile {
    var username: String
    var firstName: String
    var lastName: String
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    var loginName: String {
        "@\(username)"
    }
    var bio: String
    
    init(from profileResponse: ProfileResponse) {
        username = profileResponse.username
        firstName = profileResponse.firstName
        lastName = profileResponse.lastName
        bio = profileResponse.bio
    }
}
