//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 13.04.2025.
//

import UIKit

// MARK: - SplashViewControllerProtocol

protocol SplashViewControllerProtocol: AnyObject {
    var presenter: SplashViewPresenterProtocol? { get set }
    
    func showProfileLoadAlert()
    func navigateToImageFeedScreen()
    func navigateToLoginScreen()
    func showLoader()
    func hideLoader()
}

// MARK: - SplashViewController

final class SplashViewController: UIViewController {
    // MARK: - Properties
    
    var presenter: SplashViewPresenterProtocol?
    
    //MARK: - UI Elements
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        
        setupLogoImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let presenter = presenter else { return }
        if presenter.isAuthorized() {
            presenter.loadProfile()
        } else {
            navigateToLoginScreen()
        }
    }
    
    // MARK: - Configure UI Elements
    
    private func setupAppearance() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupLogoImageView() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate() {
        presenter?.loadProfile()
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    
    func navigateToImageFeedScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Unable to get UIWindow")
            return
        }
        
        let tabBarViewController = TabBarController()
        window.rootViewController = tabBarViewController
        
        UIView
            .transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
    }

    func navigateToLoginScreen() {
        let navigationViewController = UINavigationController()
        navigationViewController.modalPresentationStyle = .fullScreen
        
        let authViewController = AuthViewController()
        authViewController.delegate = self
        navigationViewController.viewControllers = [authViewController]
        
        show(navigationViewController, sender: self)
    }

    func showProfileLoadAlert() {
        let alert = buildAllert(
            withTitle: "Что-то пошло не так",
            andMessage: "Не удалось загрузить профиль"
        )
        present(alert, animated: true)
    }

    func showLoader() {
        UIBlockingProgressHUD.show()
    }

    func hideLoader() {
        UIBlockingProgressHUD.dismiss()
    }

    
}
