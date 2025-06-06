//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 28.03.2025.
//

import UIKit
import Kingfisher

// MARK: - Protocols

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func showLogoutAlert(okHandler: @escaping (() -> Void))
    func updateName(name: String)
    func updateLogin(login: String)
    func updateAvatar(url: URL)
    func updateDescription(description: String)
    func navigateToSplashScreen()
}

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - UI elements
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: "person.crop.circle.fill")?
                .withTintColor(.ypGray, renderingMode: .alwaysOriginal)
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.accessibilityIdentifier = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_novikova"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        label.accessibilityIdentifier = "@username"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "exit_button") ?? UIImage(), for: .normal)
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "logout button"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()

        presenter?.viewDidLoad()
    }
    
    // MARK: - actions
    
    @objc private func didTapLogoutButton() {
        presenter?.logout()
    }
    
    // MARK: - Setup UI Elements
    
    private func setupAppearance() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupLayout() {
        setupAvatarView()
        setupLogoutButton()
        setupNameLabel()
        setupLoginLabel()
        setupDescriptionLabel()
    }
    
    private func setupAvatarView() {
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    
    }
    
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor, multiplier: 1),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
        
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: .touchUpInside)
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupLoginLabel() {
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateName(name: String) {
        nameLabel.text = name
    }

    func updateLogin(login: String) {
        loginNameLabel.text = login
    }

    func updateAvatar(url: URL) {
        avatarImageView.kf.setImage(with: url)
    }

    func updateDescription(description: String) {
        descriptionLabel.text = description
    }

    func showLogoutAlert(okHandler: @escaping (() -> Void)) {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        let yesAction = UIAlertAction(
            title: "Да",
            style: .cancel,
            handler: { _ in
                okHandler()
            }
        )
        yesAction.accessibilityIdentifier = "Yes"
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        
        present(alert, animated: true)
    }
    
    func navigateToSplashScreen() {
        let splashViewController = SplashViewControllerFactory().make()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Unable to get UIWindow")
            return
        }
        window.rootViewController = splashViewController
    
        UIView
            .transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
    }
    
}

