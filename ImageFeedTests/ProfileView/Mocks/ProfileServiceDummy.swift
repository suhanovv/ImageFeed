//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 31.05.2025.
//
@testable import ImageFeed

final class ProfileServiceDummy: ProfileServiceProtocol {
    var profile: ImageFeed.Profile?

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void
    ) {}

    func logout() {
    }
}
