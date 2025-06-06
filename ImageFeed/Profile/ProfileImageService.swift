//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 29.04.2025.
//

import Foundation

// MARK: - Errors

enum ProfileImageServiceErrors: Error {
    case invalidToken
    case makeRequestFailed
}

// MARK: - Response Objects

struct ProfileImageResponse: Decodable {
    let large: String
}

struct PublicProfileResponse: Decodable {
    let profileImage: ProfileImageResponse
}

// MARK: - Protocols

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
    func logout()
}

// MARK: - ProfileImageService

final class ProfileImageService: ProfileImageServiceProtocol {
    // MARK: Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private let publicProfileApiURL = "/users/:username"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var oauth2TokenStorage = Oauth2TokenStorage.shared
    
    // MARK: Private Constructors
    
    private init() {}
    
    // MARK: - Fetch image
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = oauth2TokenStorage.token else {
            completion(.failure(ProfileImageServiceErrors.invalidToken))
            return
        }
        
        task?.cancel()
        
        guard let request = makeUrlRequestForImage(username: username, token: token) else {
            Logger.error(ProfileImageServiceErrors.makeRequestFailed)
            completion(.failure(ProfileImageServiceErrors.makeRequestFailed))
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (response: Result<PublicProfileResponse, Error>) in
            self?.task = nil
            
            switch response {
            case .success(let profileResponse):
                self?.avatarURL = profileResponse.profileImage.large
                completion(.success(profileResponse.profileImage.large))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileResponse.profileImage.large]
                    )
            case .failure(let error):
                Logger.error(error)
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func logout() {
        avatarURL = nil
    }
    
    private func makeUrlRequestForImage(username: String, token: String) -> URLRequest? {
        let defaultURL = Constants.defaultBaseURL
        
        let url = defaultURL.appendingPathComponent(self.publicProfileApiURL.replacingOccurrences(of: ":username", with: username))
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
    
}
