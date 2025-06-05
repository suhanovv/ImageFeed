//
//  ImageServiceMock.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 04.06.2025.
//
@testable import ImageFeed
import Foundation

final class ImageListServiceMock: ImageListServiceProtocol {
    enum ServiceError: Error {
        case network
    }
    struct ChangeLikeCalled {
        let photoId: String
        let isLike: Bool
    }
    
    var photos: [Photo]
    var fetchPhotosNextPageCalled = false
    var logoutCalled = false
    var changeLikeCalled: ChangeLikeCalled? = nil
    private let isChangeLikeError: Bool
    

    init(photos: [Photo], isChangeLikeError: Bool = false) {
        self.photos = photos
        self.isChangeLikeError = isChangeLikeError
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }

    func changeLike(
        photoId: String,
        isLike: Bool,
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        changeLikeCalled = ChangeLikeCalled(photoId: photoId, isLike: isLike)
        if isChangeLikeError {
            completion(.failure(ServiceError.network))
        } else {
            completion(.success(()))
        }
    }

    func logout() {
        logoutCalled = true
    }
}
