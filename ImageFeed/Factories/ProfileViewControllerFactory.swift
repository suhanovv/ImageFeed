//
//  ProfileViewControllerFactory.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 04.06.2025.
//
import UIKit

class ProfileViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let profileViewPresenter = ProfileViewPresenter(
            logoutService: ProfileLogoutService(),
            imageService: ProfileImageService.shared,
            profileService: ProfileService.shared
        )
        
        let profileViewController = ProfileViewController()
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        return profileViewController
    }
}
