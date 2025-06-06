//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 12.04.2025.
//

import UIKit
import SwiftKeychainWrapper

// MARK: - Delegate Protocols

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate()
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    // MARK: - Constants
    private enum AuthViewControllerConstants {
        static let loginButtonTitle: String = "Войти"
        static let errorAlertTitle: String = "Что-то пошло не так"
        static let errorAlertMessage: String = "Не удалось войти в систему"
    }
    
    // MARK: - Properties
    
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - UI Elements
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(resource: .logoOfUnsplash))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AuthViewControllerConstants.loginButtonTitle, for: .normal)
        button.tintColor = .ypBlack
        button.backgroundColor = .ypWhite
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "Authenticate"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
    }
    
    //MARK: - Configuration UI elements
    
    private func setupAppearance() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupLayout() {
        setupLogoImageView()
        setupLoginButton()
        setupBackButton()
    }
    
    private func setupLogoImageView() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLoginButton() {
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        guard let viewController = WebViewViewControllerFactory().make() as? WebViewViewController else { return }
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(
            resource: .navBackButtonBlack)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(
            resource: .navBackButtonBlack)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
}

//MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        UIBlockingProgressHUD.show()
        oauth2Service.fetchAuthToken(from: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let token):
                Oauth2TokenStorage.shared.token = token
                delegate?.didAuthenticate()
            case .failure(let error):
                Logger.error("Error fetching token: \(error)")
                let alert = buildAllert(
                    withTitle: AuthViewControllerConstants.errorAlertTitle,
                    andMessage: AuthViewControllerConstants.errorAlertMessage)
                present(alert, animated: true)
            }
        }
    }
}
