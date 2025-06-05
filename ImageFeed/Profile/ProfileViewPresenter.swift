//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 01.06.2025.
//

import UIKit

// MARK: - Protocols

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func logout()
}

// MARK: - ProfileViewPresenter

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Properies
    weak var view: ProfileViewControllerProtocol?
    let profileImageService: ProfileImageServiceProtocol
    let profileLogoutService: ProfileLogoutServiceProtocol
    let profileService: ProfileServiceProtocol
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Constructor
    
    init(logoutService: ProfileLogoutServiceProtocol,
         imageService: ProfileImageServiceProtocol,
         profileService: ProfileServiceProtocol
    ) {
        self.profileLogoutService = logoutService
        self.profileImageService = imageService
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        subscribeToAvatarUpdates()
        updateProfileData()
        updateAvatar()
    }
    
    private func updateProfileData() {
        guard let profile = profileService.profile else {
            return
        }
        view?.updateName(name: profile.fullName)
        view?.updateLogin(login: profile.loginName)
        view?.updateDescription(description: profile.bio ?? "")
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        Logger.info("Updating avatar from \(url)")
        view?.updateAvatar(url: url)
    }
    
    func logout() {
        view?.showLogoutAlert { [weak self] in
            self?.profileLogoutService.logout()
            self?.view?.navigateToSplashScreen()
        }
    }
    
    private func subscribeToAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
    }
}
