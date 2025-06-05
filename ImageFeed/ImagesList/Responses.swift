//
//  Responses.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 05.06.2025.
//

import Foundation

struct PhotosResponse: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let urls: PhotoUrlsResponse
    let likedByUser: Bool
    
    func toPhoto() -> Photo {
        return Photo(
            id: id,
            size: CGSize(width: width, height: height),
            createdAt: createdAt,
            description: description,
            thumbImageURL: urls.thumb,
            largeImageURL: urls.full,
            isLiked: likedByUser
        )
    }
}

struct PhotoUrlsResponse: Decodable {
    let thumb: String
    let full: String
}

struct ChangeLikePhotosResponse: Decodable {
    let photo: PhotosResponse
}
