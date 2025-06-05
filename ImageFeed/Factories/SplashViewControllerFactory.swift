//
//  ViewFactory.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 04.06.2025.
//

import UIKit


class SplashViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let splashViewPresenter = SplashViewPresenter(
            profileService: ProfileService.shared,
            tokenStorage: Oauth2TokenStorage.shared,
            profileImageService: ProfileImageService.shared
        )
        let splashViewController = SplashViewController()
        splashViewPresenter.view = splashViewController
        splashViewController.presenter = splashViewPresenter
        return splashViewController
    }
}
