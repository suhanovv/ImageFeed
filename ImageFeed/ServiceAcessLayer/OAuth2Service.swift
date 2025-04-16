//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 12.04.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}


final class OAuth2Service {
    private enum HTTPMethod: String {
        case post = "POST"
    }
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchAuthToken(from code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else { return }
        
        let task = URLSession.shared.dataTask(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                } catch {
                    print("Decoding response body error: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("Error fetching token: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.oauthTokenURL) else {
            print("Error creating URLComponents")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri)
        ]
        guard let url = urlComponents.url else {
            print("Error creating URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
    
}
