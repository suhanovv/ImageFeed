//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 22.03.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }() 
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var imageDate: UILabel!
    @IBOutlet private weak var isLikedStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
    }
    
    func configure(with image: UIImage, and date: Date, and isLikedStatusImage: UIImage) {
        cellImage.image = image
        imageDate.text = dateFormatter.string(from: date)
        isLikedStatus.setImage(isLikedStatusImage, for: .normal)
    }
}
