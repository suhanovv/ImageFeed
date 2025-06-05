//
//  WebViewViewControllerFactory.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 04.06.2025.
//

import UIKit

class WebViewViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let viewController = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = webViewPresenter
        webViewPresenter.view = viewController
        
        return viewController
    }
}
