//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 22.03.2025.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UI elements
    
    private lazy var cellImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Stub")
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageDate: UILabel = {
        let view = UILabel()
        view.textColor = .ypWhite
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var isLikedStatus: UIButton = {
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
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Configuration
    
    func configureWith(_ imageUrl: URL, andDate date: Date?, andIsLiked isLiked: Bool) {

        cellImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "Stub"),
            options: []
        )
        
        if let date {
            imageDate.text = date.imageCellDateString()
        }
        
        isLikedStatus
            .setImage(
                UIImage(named: getIsLikedImageName(isLiked: isLiked)),
                for: .normal
            )
    }
    
    func setIsLiked(isLiked: Bool) {
        isLikedStatus.setImage(
            UIImage(named: getIsLikedImageName(isLiked: isLiked)),
            for: .normal
        )
    }
    
    private func getIsLikedImageName(isLiked: Bool) -> String {
        return isLiked ? "like_button_on" : "like_button_off"
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
        let topAndBottomPadding: CGFloat = 4
        let leadingAndTrailingPadding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor
                .constraint(
                    equalTo: contentView.topAnchor,
                    constant: topAndBottomPadding
                ),
            cellImage.leadingAnchor
                .constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: leadingAndTrailingPadding
                ),
            cellImage.trailingAnchor
                .constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -leadingAndTrailingPadding
                ),
            cellImage.bottomAnchor
                .constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -topAndBottomPadding
                ),
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
        let highAndWidth: CGFloat = 44
        
        NSLayoutConstraint.activate([
            isLikedStatus.heightAnchor
                .constraint(equalToConstant: highAndWidth),
            isLikedStatus.widthAnchor.constraint(equalToConstant: highAndWidth),
            isLikedStatus.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            isLikedStatus.topAnchor.constraint(equalTo: cellImage.topAnchor),
        ])
        
        isLikedStatus.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

