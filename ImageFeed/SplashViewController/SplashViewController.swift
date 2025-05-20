//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 13.04.2025.
//

import UIKit

// MARK: - SplashViewController

final class SplashViewController: UIViewController {
    // MARK: - Properties
    
    private var oauth2TokenStorage = Oauth2TokenStorage.shared
    private var profileService: ProfileService = ProfileService.shared
    
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
        
        guard let token = oauth2TokenStorage.token else {
            showUnauthorizedArea()
            return
        }
        
        fetchProfile(token)
    }
    
    // MARK: - Show Areas
    
    private func showAuthorizedArea() {
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
    
    private func showUnauthorizedArea() {
        let navigationViewController = UINavigationController()
        navigationViewController.modalPresentationStyle = .fullScreen
        
        let authViewController = AuthViewController()
        authViewController.delegate = self
        navigationViewController.viewControllers = [authViewController]
        
        self.show(navigationViewController, sender: self)
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
    func didAuthenticate(_ vc: AuthViewController) {
        
        guard let token = oauth2TokenStorage.token else {
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.showAuthorizedArea()
            case .failure(let error):
                let alert = buildAllert(
                    withTitle: "Что-то пошло не так",
                    andMessage: "Не удалось загрузить профиль"
                )
                present(alert, animated: true)
                Logger.error(error)
            }
        }
    }
}
