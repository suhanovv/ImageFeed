//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 13.04.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case missingResponse
}

extension URLSession {
    
    func dataTask(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            let result = Self.processResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        return task
    }
    
    func objectTask<T: Codable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = dataTask(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    Logger.error("Decoding response body error: \(error), data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                Logger.error("Error fetching token: \(error)")
                completion(.failure(error))
            }
        }
        return task
    }
    
    private static func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            Logger.error(error, data: data)
            return .failure(NetworkError.urlRequestError(error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.error(NetworkError.missingResponse)
            return .failure(NetworkError.missingResponse)
        }

        let statusCode = httpResponse.statusCode

        guard (200..<300).contains(statusCode), let data = data else {
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                Logger.error("Response data: \(dataString)")
            }
            return .failure(NetworkError.httpStatusCode(statusCode))
        }

        return .success(data)
    }

}
