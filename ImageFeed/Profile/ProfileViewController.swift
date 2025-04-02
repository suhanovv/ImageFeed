//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 28.03.2025.
//

import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAvatarView(withImageName: "Avatar")
        makeLogoutButton()
        makeNameLabel(withName: "Екатерина Новикова")
        makeLoginLabel(withLogin: "@ekaterina_novikova")
        makeDescriptionLabel(withDescription: "Hello world")
    }
    
    // MARK: - actions
    
    @objc private func didTapLogoutButton() {}
    
    // MARK: - element constructors
    
    private func makeAvatarView(withImageName imageName: String) {
        avatarImageView = UIImageView(image: UIImage(named: imageName))
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImageView)
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1).isActive = true
        avatarImageView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func makeLogoutButton() {
        logoutButton = UIButton
            .systemButton(
                with: UIImage(named: "exit_button") ?? UIImage(),
                target: self,
                action: #selector(Self.didTapLogoutButton)
            )
        logoutButton.tintColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor, multiplier: 1).isActive = true
        logoutButton.trailingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor
            .constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        
    }
    
    private func makeNameLabel(withName name: String) {
        nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor
            .constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor
            .constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func makeLoginLabel(withLogin login: String) {
        loginNameLabel = UILabel()
        loginNameLabel.text = login
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginNameLabel)
        
        loginNameLabel.topAnchor
            .constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor
            .constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.trailingAnchor
            .constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
    
    private func makeDescriptionLabel(withDescription description: String) {
        descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor
            .constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor
            .constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor
            .constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
        
}
