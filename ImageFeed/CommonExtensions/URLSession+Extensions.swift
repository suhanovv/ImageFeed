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
    
    private static func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            logError(error, data: data)
            return .failure(NetworkError.urlRequestError(error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("URL Session Error — missing response")
            return .failure(NetworkError.urlSessionError)
        }

        let statusCode = httpResponse.statusCode

        guard (200..<300).contains(statusCode), let data = data else {
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data: \(dataString)")
            }
            return .failure(NetworkError.httpStatusCode(statusCode))
        }

        return .success(data)
    }
    
    private static func logError(_ error: Error, data: Data?) {
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print("Response data: \(string) with Error: \(error.localizedDescription)")
            } else {
                print("Error: \(error.localizedDescription)")
            }
        }

}
