//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 22.03.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var imageDate: UILabel!
    @IBOutlet weak var isLikedStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
    }
    
    
    
}
