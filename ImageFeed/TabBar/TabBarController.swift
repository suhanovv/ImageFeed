//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 02.05.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        configureViewControllers()
    }
    
    private func setupAppearance() {
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.backgroundImage = UIImage()
    }
    
    private func configureViewControllers() {
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
