//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 28.03.2025.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    
    private var profileService: ProfileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_novikova"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        
        subscribeToAvatarUpdates()
        
        updateProfileData()
        updateAvatar()
        
    }
    
    // MARK: - actions
    
    @objc private func didTapLogoutButton() {}
    
    // MARK: - Setup UI Elements
    
    private func setupAppearance() {
        view.backgroundColor = .ypBlack
    }
    private func setupLayout() {
        makeAvatarView()
        makeLogoutButton()
        makeNameLabel()
        makeLoginLabel()
        makeDescriptionLabel()
    }
    
    private func makeAvatarView() {
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    
    }
    
    private func makeLogoutButton() {
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor, multiplier: 1),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
        
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: .touchUpInside)
    }
    
    private func makeNameLabel() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func makeLoginLabel() {
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func makeDescriptionLabel() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    // MARK: - Profile and Avatar update handlers
    
    private func subscribeToAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateProfileData() {
        guard let profile = profileService.profile else {
            return
        }
        nameLabel.text = profile.fullName
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        Logger.info("Updating avatar from \(url)")
        avatarImageView.kf.setImage(
            with: url
        )
    }
}

