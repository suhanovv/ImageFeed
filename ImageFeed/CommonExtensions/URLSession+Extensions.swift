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
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("Response data: \(dataString)")
                    }
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                if let data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data: \(dataString) with Error: \(error.localizedDescription)")
                }
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("URL Session Error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })

        return task
    }
}
