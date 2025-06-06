//
//  Photo.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 15.05.2025.
//

import Foundation

struct Photo: Equatable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    func toggledLike() -> Photo {
        let newPhoto = Photo(
            id: id,
            size: size,
            createdAt: createdAt,
            description: description,
            thumbImageURL: thumbImageURL,
            largeImageURL: largeImageURL,
            isLiked: !isLiked
        )
        return newPhoto
        
    }
}
