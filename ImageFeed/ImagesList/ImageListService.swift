//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 15.05.2025.
//

import Foundation

// MARK: - Response Objects

private struct PhotosResponse: Decodable {
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

private struct PhotoUrlsResponse: Decodable {
    let thumb: String
    let full: String
}

private struct ChangeLikePhotosResponse: Decodable {
    let photo: PhotosResponse
}

// MARK: - ImageListService

final class ImageListService {
    // MARK: - Constants && Properties
    
    static let didChangeNotification = Notification.Name("ImageListServiceDidChange")
    static let shared = ImageListService()
    
    private let photosApiUrl = "/photos"
    private let likesApiUrl = "/photos/:id/like"
    private let perPageCount = 10
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    private var oauth2TokenStorage = Oauth2TokenStorage.shared
    private var task: URLSessionTask?
    private var urlSession = URLSession.shared
    
    // MARK: - Private Constructors
    
    private init() {}
    
    // MARK: - Fetch next page
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard let token = oauth2TokenStorage.token else {
            return
        }
        
        if let task = task {
            Logger.info("Task \(task.taskIdentifier) is already running")
            return
        }
        
        let pageNumber = getNextPageNumber()
        
        guard let request = makeImageListRequest(
            forPageNumber: pageNumber,
            andPerPageCount: perPageCount,
            andToken: token
        ) else {
            Logger.error("Error creating URLRequest")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (
            result: Result<[PhotosResponse], Error>
        ) in
            switch result {
            case .success(let photosResponse):
                Logger.info("Fetched \(photosResponse.count) photos")
                self?.photos.append(contentsOf: photosResponse.map { $0.toPhoto() })
                self?.lastLoadedPage = pageNumber
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: self)
            case .failure(let error):
                Logger.error("Failed to fetch photos: \(error)")
            }
            self?.task = nil
        }
        
        self.task = task
        
        task.resume()
    }
    
    private func makeImageListRequest(forPageNumber pageNumber: Int, andPerPageCount perPageCount: Int, andToken token: String) -> URLRequest? {
        
        guard
            let baseUrl = Constants.defaultBaseURL,
            var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(photosApiUrl), resolvingAgainstBaseURL: true)
        else {
            Logger.error("Error creating URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "per_page", value: String(perPageCount)),
        ]
        
        guard let url = urlComponents.url else {
            Logger.error("Error creating URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func getNextPageNumber() -> Int {
        lastLoadedPage + 1
    }
    
    // MARK: - Likes
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard let token = oauth2TokenStorage.token else {
            return
        }
        
        guard let request = makeToggleLikeRequest(photoId: photoId, andToken: token, isLike: isLike) else {
            Logger.error("Error creating URLRequest for likes")
            return
        }
        
        let task = urlSession.dataTask(for: request) {[weak self] (result: Result<_, Error>) in
            switch result {
            case .success:
                self?.updateLike(photoId: photoId)
                completion(.success(()))
            case .failure(let error):
                Logger.error("Failed to change like: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    private func makeToggleLikeRequest(photoId: String, andToken token: String, isLike: Bool) -> URLRequest? {
        guard let defaultURL = Constants.defaultBaseURL else {
            return nil
        }
        
        let url = defaultURL.appendingPathComponent(
            self.likesApiUrl.replacingOccurrences(of: ":id", with: photoId)
        )
        var request = URLRequest(url: url)
        if isLike {
            request.httpMethod = HTTPMethod.post.rawValue
        } else {
            request.httpMethod = HTTPMethod.delete.rawValue
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func updateLike(photoId: String) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            let photo = photos[index]
            photos[index] = photo.toggledLike()
        }
    }
    
    // MARK: - Logout logic
    
    func logout() {
        photos = []
        lastLoadedPage = 0
    }
}
