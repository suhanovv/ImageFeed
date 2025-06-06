//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 31.05.2025.
//
@testable import ImageFeed

final class ProfileImageServiceDummy: ProfileImageServiceProtocol {
    var avatarURL: String?

    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, any Error>) -> Void
    ) {}

    func logout() {
        
    }
}
