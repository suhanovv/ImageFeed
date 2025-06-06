//
//  ImagesViewControllerFactory.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 04.06.2025.
//

import UIKit

final class ImagesListViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let imagesListViewPresenter = ImagesListViewPresenter(
            imageService: ImageListService.shared
        )
        
        let imagesListViewController = ImagesListViewController()
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListViewPresenter
        
        return imagesListViewController
    }
}
