//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 22.03.2025.
//

import UIKit

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }() 
    
    // MARK: - UI elements
    
    private var cellImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var imageDate: UILabel = {
        let view = UILabel()
        view.textColor = .ypWhite
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isLikedStatus: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Constructors
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with image: UIImage, and date: Date, and isLikedStatusImage: UIImage) {
        cellImage.image = image
        imageDate.text = dateFormatter.string(from: date)
        isLikedStatus.setImage(isLikedStatusImage, for: .normal)
    }
    
    private func setupAppearance() {
        backgroundColor = .ypBlack
        selectionStyle = .none
    }
    
    private func setupLayout() {
        configureCellImage()
        configureImageDate()
        configureIsLikedStatus()
    }

    private func configureCellImage() {
        contentView.addSubview(cellImage)
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    
    private func configureImageDate() {
        contentView.addSubview(imageDate)
        NSLayoutConstraint.activate([
            imageDate.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            imageDate.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            imageDate.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8),
        ])
    }
    
    private func configureIsLikedStatus() {
        contentView.addSubview(isLikedStatus)
        NSLayoutConstraint.activate([
            isLikedStatus.heightAnchor.constraint(equalToConstant: 44),
            isLikedStatus.widthAnchor.constraint(equalToConstant: 44),
            isLikedStatus.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            isLikedStatus.topAnchor.constraint(equalTo: cellImage.topAnchor),
        ])
    }
}
