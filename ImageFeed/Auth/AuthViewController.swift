//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 12.04.2025.
//

import UIKit

// MARK: - Delegate Protocols

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let logoImageName: String = "Logo_of_Unsplash"
        static let backButtonImageName : String = "nav_back_button_black"
        static let loginButtonTitle: String = "Войти"
    }
    
    // MARK: - Properties
    
    private var oauth2TokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - UI Elements
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: Constants.logoImageName))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.loginButtonTitle, for: .normal)
        button.tintColor = .ypBlack
        button.backgroundColor = .ypWhite
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureLogoImageView()
        configureLoginButton()
        configureBackButton()
    }
    
    //MARK: - Configuration UI elements
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureLoginButton() {
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
        let viewController = WebViewViewController()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: Constants.backButtonImageName)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Constants.backButtonImageName)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        oauth2Service.fetchAuthToken(from: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                oauth2TokenStorage.token = token
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Error fetching token: \(error)")
            }
        }
    }
}
