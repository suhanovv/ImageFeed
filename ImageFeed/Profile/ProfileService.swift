//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 26.04.2025.
//

import Foundation

// MARK: - Errors

enum ProfileServiceError: Error {
    case invalidRequest
    case makeRequestFailed
    
}

// MARK: - Response Object

struct ProfileResponse: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

// MARK: - ProfileService

final class ProfileService {
    // MARK: - Properties
    
    static let shared = ProfileService()
    private let currentUserURI = "/me"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Private constructors
    
    private init() {}
    
    // MARK: - Fetch Profile
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        guard let request = makeCurrentUserRequest(token: token) else {
            Logger.error(ProfileServiceError.makeRequestFailed)
            completion(.failure(ProfileServiceError.makeRequestFailed))
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (response: Result<ProfileResponse, Error>) in
            self?.task = nil
            
            switch response {
            case .success(let profileResponse):
                
                let profile = Profile(from: profileResponse)
                self?.profile = profile
                completion(.success(profile))   
            case .failure(let error):
                Logger.error(error)
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeCurrentUserRequest(token: String) -> URLRequest? {
        guard let defaultURL = Constants.defaultBaseURL else {
            return nil
        }
        let url = defaultURL.appendingPathComponent(currentUserURI)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
    
    // MARK: - Logout
    
    func logout() {
        profile = nil
    }
}

