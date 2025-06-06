//
//  SplashViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 02.06.2025.
//

import Foundation

// MARK: - SplashViewPresenterProtocol

protocol SplashViewPresenterProtocol: AnyObject {
    var view: SplashViewControllerProtocol? { get set }
    
    func loadProfile()
    func isAuthorized() -> Bool
}

// MARK: - SplashViewPresenter

final class SplashViewPresenter: SplashViewPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: SplashViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    private let tokenStorage: Oauth2TokenStorageProtocol
    private let profileImageService: ProfileImageServiceProtocol
    
    // MARK: - Initializers
    
    init(
        profileService: ProfileServiceProtocol,
        tokenStorage: Oauth2TokenStorageProtocol,
        profileImageService: ProfileImageServiceProtocol
    ) {
        self.profileService = profileService
        self.tokenStorage = tokenStorage
        self.profileImageService = profileImageService
    }
    
    // MARK: - Protocol methods
    
    func loadProfile() {
        guard let view else {
            Logger.error("SplashViewPresenter: view is nil")
            return
        }
        guard let token = tokenStorage.token else {
            view.navigateToLoginScreen()
            return
        }
        
        view.showLoader()
        profileService.fetchProfile(token) { [weak self] result in
            view.hideLoader()
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                view.navigateToImageFeedScreen()
            case .failure(let error):
                view.showProfileLoadAlert()
                Logger.error(error)
            }
        }
    }
    
    func isAuthorized() -> Bool {
        tokenStorage.token != nil
    }
    
}
