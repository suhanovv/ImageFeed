//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 13.04.2025.
//

import UIKit


final class SplashViewController: UIViewController {
    private var oauth2TokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()
    
    //MARK: UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        configureLogoImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            showAuthorizedArea()
        } else {
            showUnauthorizedArea()
        }
    }
    
    private func showAuthorizedArea() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
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
        let authNavigationViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthNavigationViewController")
        
        authNavigationViewController.modalPresentationStyle = .fullScreen
        let authViewController = authNavigationViewController.children.first as? AuthViewController
        authViewController?.delegate = self
        
        self.show(authNavigationViewController, sender: self)
    }
    
    //MARK: Configure UI Elements
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


//MARK: AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        self.showAuthorizedArea()
    }
}
